import 'dart:async';
import 'dart:io';
import 'package:concord/models/chats_model.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/models/request_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/controllers/requests_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:concord/models/users_model.dart';

final CollectionReference usersRef =
    FirebaseFirestore.instance.collection('users');
final CollectionReference requestsRef =
    FirebaseFirestore.instance.collection('requests');
final CollectionReference chatsRef =
    FirebaseFirestore.instance.collection('chats');
final CollectionReference postsRef =
    FirebaseFirestore.instance.collection('posts');

Future<List?> signInUserFirebase(email, pass) async {
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

Future<bool> logInUserFirebase(String email, String pass) async {
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

Future<void> saveUserOnDevice(email, pass) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', pass);
}

Future<bool> autoLoginFirebase() async {
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
      debugPrint("(catch) An error occurred: $e");
      return false;
    }
  } else {
    debugPrint('failed due to : No login data found');
    return false;
  }
}

void profileListenerFirebase(currentUserId) {
  MainController mainController = Get.find<MainController>();
  mainController.profileListenerRef =
      usersRef.doc(currentUserId).snapshots().listen((event) {
    mainController.currentUserData =
        UsersModel.fromJson(event.data() as Map<String, dynamic>);
    mainController.currentUserData.id = event.id;
    mainController.update(['profileSection']);
  });
}

Future<void> updateProfileFirebase(
    currentUserId, displayName, pronouns, aboutMe, image) async {
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

Future<bool> updateStatusDisplayFirebase(userId, displayStatus) async {
  try {
    await usersRef.doc(userId).update({'displayStatus': displayStatus});
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<UsersModel>> getInitialFriendsFirebase(currentUserId) async {
  var friendInstances = await FirebaseFirestore.instance
      .collection('users')
      .orderBy('displayName')
      .where('friends', arrayContains: currentUserId)
      .get();
  List<UsersModel> friends = [];
  for (var doc in friendInstances.docs) {
    UsersModel friendUserData = UsersModel.fromJson(doc.data());
    // Map friendUserData = doc.data();
    // friendUserData['id'] = doc.id;
    friendUserData.id = doc.id;
    friends.add(friendUserData);
  }
  return friends;
}

StreamSubscription friendsListenerFirebase(
    currentUserId, Function updateFriends) {
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
        updateFriends(updateData, 'modified');
      } else if (change.type == DocumentChangeType.added) {
        updateFriends(updateData, 'added');
      } else if (change.type == DocumentChangeType.removed) {
        updateFriends(updateData, 'removed');
      }
    }
  });
}

Future<UsersModel> getUserProfileFirebase(userId) async {
  var user = await usersRef.doc(userId).get();
  UsersModel userData =
      UsersModel.fromJson(user.data() as Map<String, dynamic>);
  userData.id = user.id;
  return userData;
}

void removeFriendFirebase(currentUserId, friendId) {
  usersRef.doc(currentUserId).update({
    'friends': FieldValue.arrayRemove([friendId])
  });
  usersRef.doc(friendId).update({
    'friends': FieldValue.arrayRemove([currentUserId])
  });
}

getInitialRequestFirebase(currentUserId) async {
  var incomingRequestInstances = await FirebaseFirestore.instance
      .collection('requests')
      .orderBy('timeStamp', descending: true)
      .where('receiverId', isEqualTo: currentUserId)
      .get();
  List<RequestsModel> incoming = [];
  for (var doc in incomingRequestInstances.docs) {
    RequestsModel requestData = RequestsModel.fromJson(doc.data());
    requestData.id = doc.id;
    var user = await usersRef.doc(requestData.senderId).get();
    if (user.data() != null) {
      UsersModel userData =
          UsersModel.fromJson(user.data() as Map<String, dynamic>);
      userData.id = user.id;
      requestData.user = userData;
    }
    incoming.add(requestData);
  }
  var outgoingRequestInstances = await FirebaseFirestore.instance
      .collection('requests')
      .orderBy('timeStamp', descending: true)
      .where('senderId', isEqualTo: currentUserId)
      .get();
  List<RequestsModel> outgoing = [];
  for (var doc in outgoingRequestInstances.docs) {
    RequestsModel requestData = RequestsModel.fromJson(doc.data());
    requestData.id = doc.id;
    var user = await usersRef.doc(requestData.receiverId).get();
    if (user.data() != null) {
      UsersModel userData =
          UsersModel.fromJson(user.data() as Map<String, dynamic>);
      userData.id = user.id;
      requestData.user = userData;
    }
    outgoing.add(requestData);
  }
  return [incoming, outgoing];
}
//TODO: change to use one listener
List<StreamSubscription> requestsListenersFirebase(currentUserId) {
  RequestsController requestsController = Get.find<RequestsController>();
  return [
    FirebaseFirestore.instance
        .collection('requests')
        .orderBy('timeStamp', descending: true)
        .where('receiverId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) async {
      for (var change in event) {
        RequestsModel requestData =
            RequestsModel.fromJson(change.doc.data() as Map<String, dynamic>);
        requestData.id = change.doc.id;
        // var requestData = change.doc.data();
        // requestData?['id'] = change.doc.id;
        if (change.type == DocumentChangeType.added) {
          var user = await usersRef.doc(requestData.senderId).get();
          if (user.data() != null) {
            UsersModel userData =
                UsersModel.fromJson(user.data() as Map<String, dynamic>);
            userData.id = user.id;
            // var temp = user.data();
            // temp['id'] = user.id;
            requestData.user = userData;
          }
          requestsController.updateIncomingRequests(requestData, 'added');
        } else if (change.type == DocumentChangeType.removed) {
          requestsController.updateIncomingRequests(requestData, 'removed');
        }
      }
    }),
    FirebaseFirestore.instance
        .collection('requests')
        .orderBy('timeStamp', descending: true)
        .where('senderId', isEqualTo: currentUserId)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) async {
      for (var change in event) {
        RequestsModel requestData =
            RequestsModel.fromJson(change.doc.data() as Map<String, dynamic>);
        requestData.id = change.doc.id;
        if (change.type == DocumentChangeType.added) {
          var user = await usersRef.doc(requestData.receiverId).get();
          if (user.data() != null) {
            UsersModel userData =
                UsersModel.fromJson(user.data() as Map<String, dynamic>);
            userData.id = user.id;
            requestData.user = userData;
          }
          requestsController.updateOutgoingRequests(requestData, 'added');
        } else if (change.type == DocumentChangeType.removed) {
          requestsController.updateOutgoingRequests(requestData, 'removed');
        }
      }
    })
  ];
}

Future<void> sendRequestFirebase(currentUserId, receiverName) async {
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
      RequestsModel requestData = RequestsModel(
          senderId: currentUserId,
          receiverId: receiverRef.docs[0].id,
          timeStamp: DateTime.now());
      ref.add(requestData.toJson());
    }
  }
}

Future<void> requestActionFirebase(requestId, action) async {
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
      List<String> users = [
        requestData?['receiverId'],
        requestData?['senderId']
      ];
      ChatsModel newChat = ChatsModel(
          chatType: 'dm',
          latestMessage: '',
          timeStamp: DateTime.now(),
          users: users,
          visible: users);
      batch.set(chatsRef.doc(), newChat.toJson());
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

Future<List<ChatsModel>> getInitialChatsFirebase(currentUserId) async {
  var chatInstances = await FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timeStamp', descending: true)
      .where('visible', arrayContains: currentUserId)
      .get();
  List<ChatsModel> chats = [];
  for (var doc in chatInstances.docs) {
    ChatsModel chatData = ChatsModel.fromJson(doc.data());
    chatData.receiverData = [];
    chatData.id = doc.id;
    chatData.users.removeWhere((element) => element == currentUserId);
    for (var user in chatData.users) {
      chatData.receiverData?.add(await getUserProfileFirebase(user));
    }
    chats.add(chatData);
  }
  return chats;
}

StreamSubscription chatsListenerFirebase(currentUserId, updateChats) {
  return FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timeStamp', descending: true)
      .where('visible', arrayContains: currentUserId)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) async {
    for (var change in event) {
      ChatsModel updateData = ChatsModel.fromJson(change.doc.data()!);
      updateData.id = change.doc.id;
      if (change.type == DocumentChangeType.modified) {
        updateChats(updateData, 'modified');
      } else if (change.type == DocumentChangeType.added) {
        updateData.receiverData = [];
        updateData.users.removeWhere((element) => element == currentUserId);
        for (var userId in updateData.users) {
          updateData.receiverData?.add(await getUserProfileFirebase(userId));
        }
        updateChats(updateData, 'added');
      } else if (change.type == DocumentChangeType.removed) {
        updateChats(updateData, 'removed');
      }
    }
  });
}

createGroupFirebase(users, groupName) async {
  ChatsModel newChat = ChatsModel(
      chatType: 'group',
      latestMessage: '',
      timeStamp: DateTime.now(),
      chatGroupName: groupName,
      users: users,
      visible: users);
  await chatsRef.add(newChat.toJson());
}

Future<ChatsModel> getFriendChatFirebase(currentUserId, otherUserId) async {
  var instances = await FirebaseFirestore.instance
      .collection('chats')
      .where('chatType', isEqualTo: 'dm')
      .where('users', whereIn: [
    [currentUserId, otherUserId],
    [otherUserId, currentUserId]
  ]).get();
  if (instances.docs.isNotEmpty) {
    ChatsModel chatData = ChatsModel.fromJson(instances.docs[0].data());
    chatData.id = instances.docs[0].id;
    if (!(chatData.visible.contains(currentUserId))) {
      chatsRef.doc(chatData.id).update({
        'visible': FieldValue.arrayUnion([currentUserId])
      });
    }
    chatData.users.removeWhere((element) => element == currentUserId);
    chatData.receiverData = [];
    for (var user in chatData.users) {
      await getUserProfileFirebase(user);
      chatData.receiverData?.add(await getUserProfileFirebase(user));
    }
    return chatData;
  } else {
    ChatsModel newChat = ChatsModel(
        chatType: 'dm',
        latestMessage: '',
        timeStamp: DateTime.now(),
        users: [currentUserId, otherUserId],
        visible: [currentUserId, otherUserId]);
    await chatsRef.add(newChat.toJson());
    return getFriendChatFirebase(currentUserId, otherUserId);
  }
}

Future<bool> hideChatFirebase(chatId, currentUserId) async {
  try {
    await chatsRef.doc(chatId).update({
      'visible': FieldValue.arrayRemove([currentUserId])
    });
    return true;
  } catch (e) {
    return false;
  }
}

DateTime? currentTime;

Future<List<MessagesModel>> getInitialMessagesFirebase(
    collection, chatId) async {
  var messageInstances = await FirebaseFirestore.instance
      .collection(collection)
      .doc(chatId)
      .collection('messages')
      .orderBy('timeStamp', descending: collection == 'chats' ? true : false)
      .limit(50)
      .get();
  currentTime = DateTime.now();
  List<MessagesModel> messages = [];
  for (var message in messageInstances.docs) {
    MessagesModel messageData = MessagesModel.fromJson(message.data());
    messageData.id = message.id;
    messages.add(messageData);
  }
  return messages;
}

StreamSubscription messagesListenerFirebase(
    collection, chatId, Function updateMessages) {
  currentTime ??= DateTime.now();
  return FirebaseFirestore.instance
      .collection(collection)
      .doc(chatId)
      .collection('messages')
      .orderBy('timeStamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docChanges)
      .listen((event) async {
    for (var change in event) {
      MessagesModel updateData = MessagesModel.fromJson(change.doc.data()!);
      updateData.id = change.doc.id;
      if (change.type == DocumentChangeType.added) {
        if (updateData.timeStamp!.isAfter(currentTime!) ||
            updateData.timeStamp!.isAtSameMomentAs(currentTime!)) {
          updateMessages(updateData, 'added');
        }
      } else if (change.type == DocumentChangeType.modified) {
        updateMessages(updateData, 'modified');
      } else if (change.type == DocumentChangeType.removed) {
        updateMessages(updateData, 'removed');
      }
    }
  });
}

getMessageHistoryFirebase(collection, chatId, MessagesModel lastMessage) async {
  var messageInstances = await FirebaseFirestore.instance
      .collection(collection)
      .doc(chatId)
      .collection('messages')
      .orderBy('timeStamp', descending: collection == 'chats' ? true : false)
      .where('timeStamp', isLessThan: lastMessage.timeStamp)
      .limit(20)
      .get();
  List<MessagesModel> messages = [];
  var historyRemaining = true;
  if (messageInstances.docs.length < 20) {
    historyRemaining = false;
  }
  for (var message in messageInstances.docs) {
    MessagesModel messageData = MessagesModel.fromJson(message.data());
    messageData.id = message.id;
    messages.add(messageData);
  }
  return [messages, historyRemaining];
}

Future<void> sendMessageFirebase(
    collection, chatId, MessagesModel messageData, attachments) async {
  var collectionRef = FirebaseFirestore.instance.collection(collection);
  var chatRef = collectionRef.doc(chatId);
  var storageRef = FirebaseStorage.instance.ref();
  List<String> fileLinks = [];

  if (attachments.isNotEmpty) {
    fileLinks =
        await Future.wait(attachments.map<Future<String>>((attachment) async {
      var attachmentRef = storageRef.child('attachments/${attachment.name}');
      var task = await attachmentRef.putFile(File(attachment.path));
      var downloadUrl = task.ref.getDownloadURL();
      return downloadUrl;
    }));
    attachments = [];
  }
  messageData.timeStamp = DateTime.now();
  messageData.attachments = fileLinks;

  var batch = FirebaseFirestore.instance.batch();
  batch.set(chatRef.collection('messages').doc(), messageData.toJson());
  if (collection == 'chats') {
    batch.update(chatRef, {
      'latestMessage': messageData.message,
      'timeStamp': messageData.timeStamp
    });
  }
  batch.commit();
}

void editMessageFirebase(collection, chatId, messageId, message) {
  FirebaseFirestore.instance
      .collection(collection)
      .doc(chatId)
      .collection('messages')
      .doc(messageId)
      .update({
    'message': message,
    'edited': true,
  });
}

void deleteMessageFirebase(collection, chatId, MessagesModel message) {
  if (message.attachments != null) {
    for (String attachment in message.attachments!) {
      FirebaseStorage.instance.refFromURL(attachment).delete();
    }
  }
  FirebaseFirestore.instance
      .collection(collection)
      .doc(chatId)
      .collection('messages')
      .doc(message.id)
      .delete();
}

Future<List> getInitialPostsFirebase(currentUserId, preference) async {
  List<PostsModel> publicPosts = [];
  var publicPostsInstances = await postsRef
      .orderBy('timeStamp', descending: true)
      .where('categories', arrayContainsAny: preference)
      .get();
  for (var instance in publicPostsInstances.docs) {
    PostsModel postData =
        PostsModel.fromJson(instance.data() as Map<String, dynamic>);
    postData.receiverData = [];
    postData.id = instance.id;
    postData.participants.removeWhere((element) => element == currentUserId);
    postData.participants.removeWhere((element) => element == postData.poster);
    var posterData = await usersRef.doc(postData.poster).get();
    postData.posterData =
        UsersModel.fromJson(posterData.data() as Map<String, dynamic>);
    postData.posterData!.id = posterData.id;
    publicPosts.add(postData);
    for (var participant in postData.participants) {
      postData.receiverData?.add(await getUserProfileFirebase(participant));
    }
  }
  List<PostsModel> followingPosts = [];
  var followingPostsInstances = await postsRef
      .orderBy('timeStamp', descending: true)
      .where('followers', arrayContains: currentUserId)
      .limit(20)
      .get();
  for (var instance in followingPostsInstances.docs) {
    PostsModel postData =
        PostsModel.fromJson(instance.data() as Map<String, dynamic>);
    postData.id = instance.id;
    postData.participants.removeWhere((element) => element == currentUserId);
    postData.participants.removeWhere((element) => element == postData.poster);
    var posterData = await usersRef.doc(postData.poster).get();
    postData.posterData =
        UsersModel.fromJson(posterData.data() as Map<String, dynamic>);
    postData.posterData!.id = posterData.id;
    postData.receiverData = [];
    followingPosts.add(postData);
    for (var participant in postData.participants) {
      postData.receiverData?.add(await getUserProfileFirebase(participant));
    }
  }
  return [publicPosts, followingPosts];
}

Future<bool> sendPostFirebase(
    PostsModel newPost, MessagesModel firstMessage, attachments) async {
  try {
    var docRef = await postsRef.add(newPost.toJson());
    await sendMessageFirebase('posts', docRef.id, firstMessage, attachments);
    return true;
  } catch (e) {
    debugPrint('(catch)$e');
    return false;
  }
}
