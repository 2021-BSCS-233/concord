import 'dart:io';
import 'package:concord/models/chats_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/page_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concord/models/users_model.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final CollectionReference requestsRef =
    FirebaseFirestore.instance.collection('requests');
final CollectionReference chatsRef =
    FirebaseFirestore.instance.collection('chats');

Future<List?> signInUser(email, pass) async {
  MainController mainController = Get.find<MainController>();
  try {
    var userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
    var userInstance = usersRef.doc(userCredential.user?.uid);
    await userInstance.set(mainController.currentUserData.toJson());
    mainController.currentUserData.id = userCredential.user?.uid;
    return [true, ''];
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return [false, 'Please enter a stronger password'];
    } else if (e.code == 'email-already-in-use') {
      return [false, 'Email already in use'];
    } else {
      debugPrint('An error occurred: ${e.message}');
      return [
        false,
        'An error occurred while registering your user, Pls try again later'
      ];
    }
  } catch (e) {
    debugPrint('An error occurred: $e');
    return [false, 'An unknown error occurred, Pls try again later'];
  }
}

Future<bool> logInUser(String email, String pass) async {
  MainController mainController = Get.find<MainController>();
  try {
    var userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
    var userInstance = usersRef.doc(userCredential.user?.uid);
    userInstance.update({'status': 'Online'});
    var userData = await userInstance.get();

    mainController.currentUserData =
        UsersModel.fromJson(userData.data() as Map<String, dynamic>);
    mainController.currentUserData.id = userCredential.user?.uid;
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      debugPrint("Email not found. Please check and try again.");
      return false;
    } else {
      debugPrint("An error occurred: ${e.message}");
      return false;
    }
  } catch (e) {
    debugPrint("An error occurred: $e");
    return false;
  }
}

saveUserOnDevice(email, pass) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', pass);
}

Future<bool> autoLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  MainController mainController = Get.find<MainController>();
  var email = prefs.getString('email');
  var pass = prefs.getString('password');
  if (email != null && pass != null) {
    try {
      var userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      var userInstance = usersRef.doc(userCredential.user?.uid);
      userInstance.update({'status': 'Online'});
      var userData = await userInstance.get();

      mainController.currentUserData =
          UsersModel.fromJson(userData.data() as Map<String, dynamic>);
      mainController.currentUserData.id = userCredential.user?.uid;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint("Email not found. Please check and try again.");
        return false;
      } else {
        debugPrint("An error occurred: ${e.message}");
        return false;
      }
    } catch (e) {
      debugPrint("An error occurred: $e");
      return false;
    }
  } else {
    debugPrint('failed due to : No login data found');
    return false;
  }
}

profileListener(currentUserId) {
  MainController mainController = Get.find<MainController>();
  usersRef.doc(currentUserId).snapshots().listen((event) {
    mainController.currentUserData =
        UsersModel.fromJson(event.data() as Map<String, dynamic>);
    mainController.currentUserData.id = event.id;
    mainController.updateM.value += 1;
  });
}

updateProfile(currentUserId, displayName, pronouns, aboutMe, image) async {
  var updateData = {
    'displayName': displayName,
    'pronouns': pronouns,
    'aboutMe': aboutMe
  };
  if (image != null) {
    var storageRef = FirebaseStorage.instance.ref().child(
        'profile_pictures/$currentUserId-${DateTime.now().millisecondsSinceEpoch}.jpg');
    var task = storageRef.putFile(File(image));
    task.whenComplete(() async {
      var downloadUrl = await task.snapshot.ref.getDownloadURL();
      updateData['profilePicture'] = downloadUrl;
      usersRef.doc(currentUserId).update(updateData);
    }).catchError((error) {
      debugPrint('Image Upload failed: $error');
      usersRef.doc(currentUserId).update(updateData);
      return error;
    });
  } else {
    usersRef.doc(currentUserId).update(updateData);
  }
}

updateStatusDisplay(userId, displayStatus) async {
  try {
    await usersRef.doc(userId).update({'displayStatus': displayStatus});
    return true;
  } catch (e) {
    return false;
  }
}

getInitialFriends(currentUserId) async {
  var friendInstances = await FirebaseFirestore.instance
      .collection('users')
      .orderBy('displayName')
      .where('friends', arrayContains: currentUserId)
      .get();
  var friends = [];
  for (var doc in friendInstances.docs) {
    UsersModel friendUserData = UsersModel.fromJson(doc.data());
    // Map friendUserData = doc.data();
    // friendUserData['id'] = doc.id;
    friendUserData.id = doc.id;
    friends.add(friendUserData);
  }
  return friends;
}

friendsListener(currentUserId) async {
  FriendsController friendsController = Get.find<FriendsController>();
  return FirebaseFirestore.instance
      .collection('users')
      .orderBy('displayName')
      .where('friends', arrayContains: currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) {
    for (var change in event) {
      var updateData = UsersModel.fromJson(change.doc.data()!);
      updateData.id = change.doc.id;
      if (change.type == DocumentChangeType.modified) {
        friendsController.updateFriends(updateData, 'modified');
      } else if (change.type == DocumentChangeType.added) {
        friendsController.updateFriends(updateData, 'added');
      } else if (change.type == DocumentChangeType.removed) {
        friendsController.updateFriends(updateData, 'removed');
      }
    }
  });
}

getUserProfile(userId) async {
  return await usersRef.doc(userId).get();
}

removeFriend(currentUserId, friendId) {
  usersRef.doc(currentUserId).update({
    'friends': FieldValue.arrayRemove([friendId])
  });
  usersRef.doc(friendId).update({
    'friends': FieldValue.arrayRemove([currentUserId])
  });
}

getInitialRequest(currentUserId) async {
  var incomingInstances = await FirebaseFirestore.instance
      .collection('requests')
      .orderBy('timeStamp', descending: true)
      .where('receiverId', isEqualTo: currentUserId)
      .get();
  var incoming = [];
  for (var doc in incomingInstances.docs) {
    var requestData = doc.data();
    requestData['id'] = doc.id;
    dynamic user = await usersRef.doc(doc['senderId']).get();
    if (user.data() != null) {
      var temp = user.data();
      temp['id'] = user.id;
      requestData['user'] = temp;
    }
    incoming.add(requestData);
  }
  var outgoingInstances = await FirebaseFirestore.instance
      .collection('requests')
      .orderBy('timeStamp', descending: true)
      .where('senderId', isEqualTo: currentUserId)
      .get();
  var outgoing = [];
  for (var doc in outgoingInstances.docs) {
    var requestData = doc.data();
    requestData['id'] = doc.id;
    dynamic user = await usersRef.doc(doc['receiverId']).get();
    if (user.data() != null) {
      var temp = user.data();
      temp['id'] = user.id;
      requestData['user'] = temp;
    }
    outgoing.add(requestData);
  }
  return [incoming, outgoing];
}

requestsListeners(currentUserId) {
  RequestsController requestsController = Get.find<RequestsController>();
  FirebaseFirestore.instance
      .collection('requests')
      .orderBy('timeStamp', descending: true)
      .where('receiverId', isEqualTo: currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) async {
    for (var change in event) {
      var requestData = change.doc.data();
      requestData?['id'] = change.doc.id;
      if (change.type == DocumentChangeType.added) {
        dynamic user = await usersRef.doc(requestData?['senderId']).get();
        if (user.data() != null) {
          var temp = user.data();
          temp['id'] = user.id;
          requestData?['user'] = temp;
        }
        requestsController.updateIncomingRequests(requestData, 'added');
      } else if (change.type == DocumentChangeType.removed) {
        requestsController.updateIncomingRequests(requestData, 'removed');
      }
    }
  });
  FirebaseFirestore.instance
      .collection('requests')
      .orderBy('timeStamp', descending: true)
      .where('senderId', isEqualTo: currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) async {
    for (var change in event) {
      var requestData = change.doc.data();
      requestData?['id'] = change.doc.id;
      if (change.type == DocumentChangeType.added) {
        dynamic user = await usersRef.doc(requestData?['receiverId']).get();
        if (user.data() != null) {
          var temp = user.data();
          temp['id'] = user.id;
          requestData?['user'] = temp;
        }
        requestsController.updateOutgoingRequests(requestData, 'added');
      } else if (change.type == DocumentChangeType.removed) {
        requestsController.updateOutgoingRequests(requestData, 'removed');
      }
    }
  });
}

sendRequest(currentUserId, receiverName) async {
  var ref = FirebaseFirestore.instance.collection('requests');
  var receiverRef =
      await usersRef.where('username', isEqualTo: receiverName).get();
  if (receiverRef.docs.isNotEmpty) {
    var check1 = await ref
        .where('senderId', isEqualTo: currentUserId)
        .where('receiverId', isEqualTo: receiverRef.docs[0].id)
        .get();
    var check2 = await ref
        .where('senderId', isEqualTo: currentUserId)
        .where('receiverId', isEqualTo: receiverRef.docs[0].id)
        .get();
    if (check1.docs.isEmpty && check2.docs.isEmpty) {
      ref.add({
        'senderId': currentUserId,
        'receiverId': receiverRef.docs[0].id,
        'timeStamp': DateTime.now(),
      });
    }
  }
}

requestAction(requestId, action) async {
  try {
    var ref = FirebaseFirestore.instance.collection('requests').doc(requestId);
    var batch = FirebaseFirestore.instance.batch();
    var requestData = (await ref.get()).data();
    if (action == 'accept') {
      batch.update(usersRef.doc(requestData?['receiverId']), {
        'friends': FieldValue.arrayUnion([requestData?['senderId']])
      });
      batch.update(usersRef.doc(requestData?['senderId']), {
        'friends': FieldValue.arrayUnion([requestData?['receiverId']])
      });
      batch.set(chatsRef.doc(), {
        'chatType': 'dm',
        'latestMessage': '',
        'timeStamp': DateTime.now(),
        'users': [requestData?['receiverId'], requestData?['senderId']]
      });
      batch.delete(ref);
      batch.commit();
      // usersRef.doc(requestData?['receiverId']).update({
      //   'friends': FieldValue.arrayUnion([requestData?['senderId']])
      // });
      // usersRef.doc(requestData?['senderId']).update({
      //   'friends': FieldValue.arrayUnion([requestData?['receiverId']])
      // });
      // chatsRef.add({
      //   'chatType': 'dm',
      //   'latestMessage': '',
      //   'timeStamp': DateTime.now(),
      //   'users': [requestData?['receiverId'], requestData?['senderId']]
      // });
      // ref.delete();
    } else if (action == 'deny') {
      ref.delete();
    }
  } catch (e) {
    debugPrint('error $e');
  }
}
//TODO: test the changes
getInitialChats(currentUserId) async {
  var chatInstances = await FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timeStamp', descending: true)
      .where('users', arrayContains: currentUserId)
      .get();
  var chats = [];
  for (var doc in chatInstances.docs) {
    ChatsModel chatData = ChatsModel.fromJson(doc.data());
    chatData.id = doc.id;
    chatData.users.removeWhere((element) => element == currentUserId);
    if (chatData.chatType == 'dm') {
      dynamic user = await usersRef.doc(chatData.users[0]).get();
      if (user.data() != null) {
        var temp = UsersModel.fromJson(user.data());
        temp.id = user.id;
        chatData.receiverData?.add(temp);
      }
      chats.add(chatData);
    }
  }
  return chats;
}

chatsListener(currentUserId, updateChats) async {
  return FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timeStamp', descending: true)
      .where('users', arrayContains: currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) async {
    for (var change in event) {
      ChatsModel updateData = ChatsModel.fromJson(change.doc.data()!);
      updateData.id = change.doc.id;
      // var updateData = change.doc.data();
      // updateData?['id'] = change.doc.id;
      if (change.type == DocumentChangeType.modified) {
        updateChats(updateData, 'modified');
      } else if (change.type == DocumentChangeType.added) {
        updateData.users.removeWhere((element) => element == currentUserId);
        if (updateData.chatType == 'dm') {
          dynamic user = await usersRef.doc(updateData.users[0]).get();
          if (user.data() != null) {
            var temp = UsersModel.fromJson(user.data());
            temp.id = user.id;
            updateData.receiverData?.add(temp);
          }
        }
        updateChats(updateData, 'added');
      }
    }
  });
}

getInitialMessages(chatId) async {
  var messageInstances = await FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timeStamp', descending: true)
      .get();
  var messages = [];
  for (var message in messageInstances.docs) {
    var temp = message.data();
    temp['id'] = message.id;
    messages.add(temp);
  }
  return messages;
}

messagesListener(chatId) async {
  ChatController chatController = Get.find<ChatController>();
  FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timeStamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) async {
    for (var change in event) {
      var updateData = change.doc.data();
      updateData?['id'] = change.doc.id;
      if (change.type == DocumentChangeType.added) {
        chatController.updateMessages(updateData, 'added');
      } else if (change.type == DocumentChangeType.modified) {
        chatController.updateMessages(updateData, 'modified');
      } else if (change.type == DocumentChangeType.removed) {
        chatController.updateMessages(updateData, 'removed');
      }
    }
  });
}

sendMessageFirebase(chatId, message, clientUserId, attachments) async {
  var chatRef = chatsRef.doc(chatId);
  var storageRef = FirebaseStorage.instance.ref();
  var fileLinks = [];

  if (attachments.isNotEmpty) {
    fileLinks =
        await Future.wait(attachments.map<Future<String>>((attachment) async {
      var attachmentRef = storageRef.child('attachments/${attachment.name}');
      var task = await attachmentRef.putFile(File(attachment.path));
      var downloadUrl = task.ref.getDownloadURL();
      return downloadUrl;
    }));
  }
  var time = DateTime.now();
  var batch = FirebaseFirestore.instance.batch();
  batch.set(chatRef.collection('messages').doc(), {
    'senderId': clientUserId,
    'timeStamp': time,
    'message': message,
    'edited': false,
    'attachments': fileLinks
  });
  batch.update(chatRef, {'latestMessage': message, 'timeStamp': time});
  batch.commit();
}

editMessageFirebase(chatId, messageId, message) {
  chatsRef.doc(chatId).collection('messages').doc(messageId).update({
    'message': message,
    'edited': true,
  });
}

deleteMessageFirebase(chatId, messageId) {
  chatsRef.doc(chatId).collection('messages').doc(messageId).delete();
}
