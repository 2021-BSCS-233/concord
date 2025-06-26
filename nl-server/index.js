require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const admin = require('firebase-admin');
const { LanguageServiceClient } = require('@google-cloud/language');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
//    cors: {
//        origin: "http://localhost:3000",
//        methods: ["GET", "POST"]
//    }
});
const port = 3000;
app.use(express.json());
app.use(express.urlencoded({
    extended: true,
}));

if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    console.error('GOOGLE_APPLICATION_CREDENTIALS environment variable is not set!');
    console.error('Please set it to the path of your service account key JSON file.');
    process.exit(1); // Exit if credentials are not configured
}
const nlClient = new LanguageServiceClient();

const serviceAccount = require(process.env.FIREBASE_ADMIN_SDK_KEY_PATH);
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});
const db = admin.firestore();

app.post('/classify-text', async (req, res) => {
    text = req.body['text'];
    if ((!text || typeof text !== 'string') && text != '') {
        return res.status(400).json({ error: 'Invalid input: "text" field is required.' });
    }
    try {
        const document = { content: text, type: 'PLAIN_TEXT' };
        const features = {extractEntities: true};
        const [result] = await nlClient.annotateText({ document, features });
        const entities = result.entities.map(entity => ({
                    name: entity.name,
                    type: entity.type, // e.g., 'OTHER', 'ORGANIZATION', 'COMPUTER'
                    salience: entity.salience, // How relevant the entity is to the text
                    mentions: entity.mentions.map(mention => mention.text.content) // Where it appeared in text
                }));
        console.log(entities);
        categoriesPost(entities);
        res.status(200).json({ entities: entities });
    } catch (error) {
        console.error('Error classifying text:', error);
        res.status(500).json({ error: 'Failed to classify text.' });
    }
});

const connectedUsers = new Set();

io.on('connection', (socket) => {
    console.log(`User connected: ${socket.id}`);

    let userId = null; // To store the user ID for this socket

    socket.on('register_user', async (uid) => {
        userId = uid;
        if (userId) {
            console.log(`User ${userId} registered with socket ${socket.id}`);
            await db.collection('users').doc(userId).update({
                status: "Online",
            }).catch(err => console.error(`Error setting ${userId} online:`, err));
        }
    });

    socket.on('user_status_update', async (data) => {
            const { uid, status } = data;
            if (uid) {
                await db.collection('users').doc(uid).update({
                    status: status,
                }).catch(err => console.error(`Error setting ${userId} online:`, err));
            }
        });

    socket.on('disconnect', async () => {
        console.log(`User disconnected: ${socket.id}`);
        if (userId) {
            console.log(`Setting user ${userId} offline`);
            await db.collection('users').doc(userId).update({
                status: "Offline",
            }).then(async ()=>{
                connectedUsers.delete(userId);
            }).catch(err => console.error(`Error setting ${userId} offline:`, err));
        }
    });
});


async function gracefulShutdown() {
    io.close();

    if (connectedUsers.size > 0) {
        console.log(`Setting ${connectedUsers.size} users offline in Firebase...`);
        const batch = db.batch();
        for (const uid of connectedUsers) {
            const userRef = db.collection('users').doc(uid);
            batch.update(userRef, {
                isOnline: false,
                isIdle: false,
                lastOnline: admin.firestore.FieldValue.serverTimestamp()
            });
        }
        try {
            await batch.commit();
            console.log('All connected users set offline in Firebase.');
        } catch (error) {
            console.error('Error setting users offline during shutdown:', error);
        }
    } else {
        console.log('No active users to set offline.');
    }

    server.close(() => {
        console.log('HTTP server closed.');
        process.exit(0);
    });

    setTimeout(() => {
        console.warn('Forcefully shutting down after timeout.');
        process.exit(1);
    }, 10000);
}

process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);

function categoriesPost(entities){
    //TODO: finish this
}

server.listen(port, () => {
    console.log(`Server listening at http://localhost:${port}`);
});