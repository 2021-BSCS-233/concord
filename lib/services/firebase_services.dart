import 'dart:async';
import 'dart:io';
import 'package:concord/models/chats_model.dart';
import 'package:concord/models/messages_model.dart';
import 'package:concord/models/notifications_model.dart';
import 'package:concord/models/posts_model.dart';
import 'package:concord/models/request_model.dart';
import 'package:concord/models/settings_model.dart';
import 'package:concord/services/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:concord/controllers/main_controller.dart';
import 'package:concord/models/users_model.dart';

//TODO: figure proper use of cache data for faster loading

class MyAuthentication {
  final FirebaseAuth authRef = FirebaseAuth.instance;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference settingsRef =
      FirebaseFirestore.instance.collection('settings');
  final MySocket mySocket = MySocket();

  Future<List?> signInUserFirebase(String email, String pass) async {
    MainController mainController = Get.find<MainController>();
    try {
      var userCredential = await authRef.createUserWithEmailAndPassword(
          email: email, password: pass);
      var userId = userCredential.user?.uid;

      DocumentReference userInstance = usersRef.doc(userId);
      await userInstance.set(mainController.currentUserData.toJson());

      SettingsModel userSettings = SettingsModel.defaultSettings();
      DocumentReference settingsInstance = settingsRef.doc(userId);
      await settingsInstance.set(userSettings.toJson());
      userSettings.docRef = settingsInstance;

      mainController.currentUserData.id = userId;
      mainController.currentUserData.docRef = userInstance;
      mainController.initializeControllers(userSettings);

      mySocket.connectSocket(userId);
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
      debugPrint('An error occurred during signin: $e');
      return [false, 'An unknown error occurred, Pls try again later'];
    }
  }

  Future<bool> logInUserFirebase(String email, String pass) async {
    MainController mainController = Get.find<MainController>();
    try {
      var userCredential = await authRef.signInWithEmailAndPassword(
          email: email, password: pass);
      var userId = userCredential.user?.uid;

      var userData = await usersRef.doc(userId).get();
      var settingsData = await settingsRef.doc(userId).get();
      SettingsModel userSettings;
      if (!settingsData.exists) {
        userSettings = SettingsModel.defaultSettings();
        userSettings.docRef = settingsRef.doc(userId);
        await userSettings.docRef!.set(userSettings.toJson());
      } else {
        userSettings =
            SettingsModel.fromJson(settingsData.data() as Map<String, dynamic>);
        userSettings.docRef = settingsData.reference;
      }

      mainController.currentUserData =
          UsersModel.fromJson(userData.data() as Map<String, dynamic>);
      mainController.currentUserData.id = userId;
      mainController.currentUserData.docRef = userData.reference;
      mainController.initializeControllers(userSettings);

      mySocket.connectSocket(userId);
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
      debugPrint("An error occurred during login: $e");
      return false;
    }
  }

  Future<bool> autoLoginFirebase() async {
    MainController mainController = Get.find<MainController>();
    User? currentUser = authRef.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      try {
        var userData = await usersRef.doc(userId).get();
        var settingsData = await settingsRef.doc(userId).get();
        SettingsModel userSettings;
        if (!settingsData.exists) {
          userSettings = SettingsModel.defaultSettings();
          userSettings.docRef = settingsRef.doc(userId);
          await userSettings.docRef!.set(userSettings.toJson());
        } else {
          userSettings = SettingsModel.fromJson(
              settingsData.data() as Map<String, dynamic>);
          userSettings.docRef = settingsData.reference;
        }

        mainController.currentUserData =
            UsersModel.fromJson(userData.data() as Map<String, dynamic>);
        mainController.currentUserData.id = userId;
        mainController.currentUserData.docRef = userData.reference;
        mainController.initializeControllers(userSettings);

        mySocket.connectSocket(userId);
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
        debugPrint("(catch) An error occurred during auto login: $e");
        return false;
      }
    } else {
      debugPrint('No login data found');
      return false;
    }
  }

  static logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}

class MyFirestore {
  final MainController mainController = Get.find<MainController>();
  final FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference<Map<String, dynamic>> settingsRef =
      FirebaseFirestore.instance.collection('settings');
  final CollectionReference<Map<String, dynamic>> requestsRef =
      FirebaseFirestore.instance.collection('requests');
  final CollectionReference<Map<String, dynamic>> chatsRef =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference<Map<String, dynamic>> postsRef =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference<Map<String, dynamic>> notificationsRef =
      FirebaseFirestore.instance.collection('notifications');

//TODO: stop using listener for this (maybe)
  void profileListenerFirebase(String currentUserId) {
    mainController.profileListenerRef ??=
        usersRef.doc(currentUserId).snapshots().listen((event) {
      mainController.currentUserData =
          UsersModel.fromJson(event.data() as Map<String, dynamic>);
      mainController.currentUserData.id = event.id;
      mainController.currentUserData.docRef = event.reference;
      mainController.update(['profileSection']);
    });
  }

  void saveSettingsFirebase(SettingsModel settings) {
    settingsRef.doc(mainController.currentUserData.id).set(settings.toJson());
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

  Future<bool> updateStatusDisplayFirebase(
      String userId, String displayStatus) async {
    try {
      await usersRef.doc(userId).update({'displayStatus': displayStatus});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UsersModel>> getInitialFriendsFirebase(
      String currentUserId) async {
    var friendInstances = await usersRef
        .orderBy('displayName')
        .where('friends', arrayContains: currentUserId)
        .get();
    // .get(const GetOptions( source: Source.cache)); // test this later
    List<UsersModel> friends = [];
    for (var doc in friendInstances.docs) {
      UsersModel friendUserData = UsersModel.fromJson(doc.data());
      friendUserData.id = doc.id;
      friendUserData.docRef = doc.reference;
      friends.add(friendUserData);
    }
    return friends;
  }

  StreamSubscription friendsListenerFirebase(
      String currentUserId, Function updateFriends) {
    return usersRef
        .orderBy('displayName')
        .where('friends', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) {
      for (var change in event) {
        var updateData = UsersModel.fromJson(change.doc.data()!);
        updateData.id = change.doc.id;
        updateData.docRef = change.doc.reference;
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

  Future<UsersModel> getUserProfileFirebase(String userId) async {
    var user = await usersRef.doc(userId).get();
    UsersModel userData =
        UsersModel.fromJson(user.data() as Map<String, dynamic>);
    userData.id = user.id;
    userData.docRef = user.reference;
    return userData;
  }

  void removeFriendFirebase(String currentUserId, String friendId) {
    usersRef.doc(currentUserId).update({
      'friends': FieldValue.arrayRemove([friendId])
    });
    usersRef.doc(friendId).update({
      'friends': FieldValue.arrayRemove([currentUserId])
    });
  }

  Future<List> getInitialRequestFirebase(String currentUserId) async {
    var incomingRequestInstances = await requestsRef
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
        userData.docRef = user.reference;
        requestData.user = userData;
      }
      incoming.add(requestData);
    }
    var outgoingRequestInstances = await requestsRef
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
        userData.docRef = user.reference;
        requestData.user = userData;
      }
      outgoing.add(requestData);
    }
    return [incoming, outgoing];
  }

  StreamSubscription requestsListenersFirebase(
      String currentUserId, Function updateRequests) {
    return requestsRef
        .orderBy('timeStamp', descending: true)
        .where(Filter.or(
          Filter('receiverId', isEqualTo: currentUserId),
          Filter('senderId', isEqualTo: currentUserId),
        ))
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) async {
      for (var change in event) {
        RequestsModel requestData =
            RequestsModel.fromJson(change.doc.data() as Map<String, dynamic>);
        requestData.id = change.doc.id;
        bool sender = requestData.senderId == currentUserId ? true : false;
        if (change.type == DocumentChangeType.added) {
          requestData.user = await getUserProfileFirebase(
              sender ? requestData.receiverId : requestData.senderId);
          updateRequests(requestData, 'added', sender);
        } else if (change.type == DocumentChangeType.removed) {
          updateRequests(requestData, 'removed', sender);
        }
      }
    });
  }

  Future<String> sendRequestFirebase(
      UsersModel currentUser, String receiverName) async {
    var receiverRef =
        await usersRef.where('username', isEqualTo: receiverName).get();
    if (receiverRef.docs.isNotEmpty) {
      if (mainController.currentUserData.friends
          .contains(receiverRef.docs[0].id)) {
        return 'User is Friends with you';
      } else {
        var check1 = await requestsRef
            .where('senderId', isEqualTo: currentUser.id)
            .where('receiverId', isEqualTo: receiverRef.docs[0].id)
            .get();
        var check2 = await requestsRef
            .where('senderId', isEqualTo: currentUser.id)
            .where('receiverId', isEqualTo: receiverRef.docs[0].id)
            .get();
        if (check1.docs.isEmpty && check2.docs.isEmpty) {
          RequestsModel requestData = RequestsModel(
              senderId: currentUser.id!,
              receiverId: receiverRef.docs[0].id,
              timeStamp: DateTime.now(),
              senderDocRef: currentUser.docRef!,
              receiverDocRef: receiverRef.docs[0].reference);
          requestsRef.add(requestData.toJson());
          return "Request Sent";
        } else {
          return "Request Already Sent";
        }
      }
    } else {
      return "User Not Found";
    }
  }

  Future<void> requestActionFirebase(String requestId, String action) async {
    try {
      var ref = requestsRef.doc(requestId);
      var batch = firestoreRef.batch();
      RequestsModel requestData = RequestsModel.fromJson(
          (await ref.get()).data() as Map<String, dynamic>);
      if (action == 'accept') {
        batch.update(requestData.receiverDocRef, {
          'friends': FieldValue.arrayUnion([requestData.senderId])
        });
        batch.update(requestData.senderDocRef, {
          'friends': FieldValue.arrayUnion([requestData.receiverId])
        });
        NotificationsModel notificationsData = NotificationsModel(
            sourceType: 'requests',
            fromUser: '',
            toUsers: [requestData.senderId, requestData.receiverId],
            timeStamp: DateTime.now());
        batch.set(notificationsRef.doc(), notificationsData.toJson());
        getUserChatFirebase(requestData.receiverId, requestData.senderId);
        batch.delete(ref);
        batch.commit();
      } else if (action == 'deny') {
        ref.delete();
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<List<ChatsModel>> getInitialChatsFirebase(String currentUserId) async {
    var chatInstances = await chatsRef
        .orderBy('timeStamp', descending: true)
        .where('visible', arrayContains: currentUserId)
        .get();
    List<ChatsModel> chats = [];
    for (var doc in chatInstances.docs) {
      ChatsModel chatData = ChatsModel.fromJson(doc.data());
      chatData.receiverData = [];
      chatData.id = doc.id;
      chatData.docRef = doc.reference;
      chatData.users.removeWhere((element) => element == currentUserId);
      for (var user in chatData.users) {
        chatData.receiverData?.add(await getUserProfileFirebase(user));
      }
      chats.add(chatData);
    }
    return chats;
  }

  StreamSubscription chatsListenerFirebase(
      String currentUserId, DateTime timeStamp, Function updateChats) {
    return chatsRef
        .orderBy('timeStamp', descending: true)
        .where('visible', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) async {
      for (var change in event) {
        ChatsModel updateData = ChatsModel.fromJson(change.doc.data()!);
        updateData.id = change.doc.id;
        updateData.docRef = change.doc.reference;
        if (change.type == DocumentChangeType.added &&
            updateData.timeStamp.isAfter(timeStamp)) {
          updateData.receiverData = [];
          updateData.users.removeWhere((element) => element == currentUserId);
          for (var userId in updateData.users) {
            updateData.receiverData?.add(await getUserProfileFirebase(userId));
          }
          updateChats(updateData, 'added');
        } else if (change.type == DocumentChangeType.modified) {
          updateChats(updateData, 'modified');
        } else if (change.type == DocumentChangeType.removed) {
          updateChats(updateData, 'removed');
        }
      }
    });
  }

  Future<void> createGroupFirebase(List<String> users, String groupName) async {
    ChatsModel newChat = ChatsModel(
        chatType: 'group',
        latestMessage: '',
        attachmentCount: 0,
        timeStamp: DateTime.now(),
        chatGroupName: groupName,
        users: users,
        visible: users,
        groupOwner: users.last,
        noNotifications: [],
        onlyMentions: []);
    await chatsRef.add(newChat.toJson());
  }

  Future<ChatsModel> getUserChatFirebase(
      String currentUserId, String otherUserId) async {
    var instances = await chatsRef
        .where('chatType', isEqualTo: 'dm')
        .where('users', whereIn: [
      [currentUserId, otherUserId],
      [otherUserId, currentUserId]
    ]).get();
    if (instances.docs.isNotEmpty) {
      ChatsModel chatData = ChatsModel.fromJson(instances.docs[0].data());
      chatData.id = instances.docs[0].id;
      chatData.docRef = instances.docs[0].reference;
      if (!(chatData.visible.contains(currentUserId))) {
        chatData.docRef?.update({
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
          attachmentCount: 0,
          timeStamp: DateTime.now(),
          users: [currentUserId, otherUserId],
          visible: [currentUserId, otherUserId],
          groupOwner: '',
          chatGroupName: '',
          noNotifications: [],
          onlyMentions: []);
      await chatsRef.add(newChat.toJson());
      return getUserChatFirebase(currentUserId, otherUserId);
    }
  }

  Future<bool> hideChatFirebase(String chatId, String currentUserId) async {
    try {
      await chatsRef.doc(chatId).update({
        'visible': FieldValue.arrayRemove([currentUserId])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<MessagesModel>> getInitialMessagesFirebase(
      DocumentReference docRef) async {
    var messageInstances = await docRef
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .limit(50)
        .get();
    List<MessagesModel> messages = [];
    for (var message in messageInstances.docs) {
      MessagesModel messageData = MessagesModel.fromJson(message.data());
      messageData.id = message.id;
      messageData.docRef = message.reference;
      if (messageData.repliedTo != null) {
        var rmData = await docRef
            .collection('messages')
            .doc(messageData.repliedTo)
            .get();
        if (rmData.data() != null) {
          messageData.repliedMessage =
              MessagesModel.fromJson(rmData.data() as Map<String, dynamic>);
          messageData.repliedMessage!.id = rmData.id;
          messageData.repliedMessage!.docRef = rmData.reference;
        }
      }
      messages.add(messageData);
    }
    return messages;
  }

  StreamSubscription messagesListenerFirebase(
      DocumentReference docRef, DateTime timeStamp, Function updateMessages) {
    return docRef
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) async {
      for (var change in event) {
        MessagesModel updateData = MessagesModel.fromJson(change.doc.data()!);
        updateData.id = change.doc.id;
        updateData.docRef = change.doc.reference;
        if (updateData.repliedTo != null) {
          var rmData = await docRef
              .collection('messages')
              .doc(updateData.repliedTo)
              .get();
          if (rmData.data() != null) {
            updateData.repliedMessage =
                MessagesModel.fromJson(rmData.data() as Map<String, dynamic>);
            updateData.repliedMessage!.id = rmData.id;
            updateData.repliedMessage!.docRef = rmData.reference;
          }
        }
        if (change.type == DocumentChangeType.added &&
            updateData.timeStamp!.isAfter(timeStamp)) {
          updateMessages(updateData, 'added');
        } else if (change.type == DocumentChangeType.modified) {
          updateMessages(updateData, 'modified');
        } else if (change.type == DocumentChangeType.removed) {
          updateMessages(updateData, 'removed');
        }
      }
    });
  }

  Future<List> getMessageHistoryFirebase(
      DocumentReference docRef, MessagesModel lastMessage) async {
    var messageInstances = await docRef
        .collection('messages')
        .orderBy('timeStamp', descending: true)
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
      messageData.docRef = message.reference;
      if (messageData.repliedTo != null) {
        var rmData = await docRef
            .collection('messages')
            .doc(messageData.repliedTo)
            .get();
        if (rmData.data() != null) {
          messageData.repliedMessage =
              MessagesModel.fromJson(rmData.data() as Map<String, dynamic>);
          messageData.repliedMessage!.id = rmData.id;
          messageData.repliedMessage!.docRef = rmData.reference;
        }
      }
      messages.add(messageData);
    }
    return [messages, historyRemaining];
  }

  Future<void> sendMessageFirebase(String collection, DocumentReference docRef,
      MessagesModel messageData, List attachments) async {
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

    var batch = firestoreRef.batch();
    batch.set(docRef.collection('messages').doc(), messageData.toJson());
    if (collection == 'chats') {
      batch.update(docRef, {
        'latestMessage': messageData.message,
        'attachmentCount': attachments.length,
        'timeStamp': messageData.timeStamp
      });
    } else if (collection == 'posts') {
      //TODO: finish later
    }
    batch.commit();
  }

  void editMessageFirebase(DocumentReference docRef, String message) {
    docRef.update({
      'message': message,
      'edited': true,
    });
  }

  void deleteMessageFirebase(MessagesModel message) {
    if (message.attachments.isNotEmpty) {
      for (String attachment in message.attachments) {
        FirebaseStorage.instance.refFromURL(attachment).delete();
      }
    }
    message.docRef!.delete();
  }

  Future<List> getInitialPostsFirebase(
      String currentUserId, List<String> preference) async {
    processPostData(data) async {
      List<PostsModel> processedPosts = [];
      for (var doc in data.docs) {
        PostsModel postData =
            PostsModel.fromJson(doc.data() as Map<String, dynamic>);
        postData.id = doc.id;
        postData.docRef = doc.reference;
        postData.participants
            .removeWhere((element) => element == currentUserId);
        postData.participants
            .removeWhere((element) => element == postData.poster);
        var posterData = await usersRef.doc(postData.poster).get();
        postData.posterData =
            UsersModel.fromJson(posterData.data() as Map<String, dynamic>);
        postData.posterData!.id = posterData.id;
        postData.posterData!.docRef = posterData.reference;
        postData.receiverData = [];
        for (var participant in postData.participants) {
          postData.receiverData?.add(await getUserProfileFirebase(participant));
        }
        processedPosts.add(postData);
      }
      return processedPosts;
    }

    var publicPostsInstances = await postsRef
        .orderBy('timeStamp', descending: true)
        .where('categories', arrayContainsAny: preference)
        .limit(20)
        .get();

    var followingPostsInstances = await postsRef
        .orderBy('timeStamp', descending: true)
        .where('followers', arrayContains: currentUserId)
        .limit(20)
        .get();
    return [
      await processPostData(publicPostsInstances),
      await processPostData(followingPostsInstances)
    ];
  }

  Future<bool> sendPostFirebase(
      PostsModel newPost, MessagesModel firstMessage, List attachments) async {
    try {
      var docRef = await postsRef.add(newPost.toJson());
      await sendMessageFirebase('posts', docRef, firstMessage, attachments);
      return true;
    } catch (e) {
      debugPrint('(catch)$e');
      return false;
    }
  }

  Future<List<NotificationsModel>> getNotificationsFirebase(
      String currentUserId) async {
    var instances = await notificationsRef
        .where('toUsers', arrayContains: currentUserId)
        .orderBy('timeStamp', descending: true)
        .limit(30)
        .get();
    List<NotificationsModel> notifications = [];
    for (var doc in instances.docs) {
      NotificationsModel notificationData =
          NotificationsModel.fromJson(doc.data());
      notificationData.id = doc.id;
      notificationData.docRef = doc.reference;

      if (notificationData.sourceType == 'posts') {
        notificationData.fromUserData =
            await getUserProfileFirebase(notificationData.fromUser);
        var postData = await notificationData.sourceDoc!.get();
        notificationData.sourcePostData =
            PostsModel.fromJson(postData.data() as Map<String, dynamic>);
        notificationData.sourcePostData!.id = postData.id;
        notificationData.sourcePostData!.docRef = postData.reference;
      } else if (notificationData.sourceType == 'requests') {
        notificationData.toUsers.remove(currentUserId);
        notificationData.fromUserData =
            await getUserProfileFirebase(notificationData.toUsers[0]);
      }
      notifications.add(notificationData);
    }
    return notifications;
  }

  StreamSubscription notificationsListenerFirebase(
      String currentUserId, Function updateNotifications) {
    return notificationsRef
        .where('toUsers', arrayContains: currentUserId)
        .orderBy('timeStamp', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) => snapshot.docChanges)
        .listen((event) async {
      for (var change in event) {
        NotificationsModel updateData = NotificationsModel.fromJson(
            change.doc.data() as Map<String, dynamic>);
        updateData.id = change.doc.id;
        updateData.docRef = change.doc.reference;

        if (updateData.sourceType == 'posts') {
          updateData.fromUserData =
              await getUserProfileFirebase(updateData.fromUser);
          var postData = await updateData.sourceDoc!.get();
          updateData.sourcePostData =
              PostsModel.fromJson(postData.data() as Map<String, dynamic>);
          updateData.sourcePostData!.id = postData.id;
          updateData.sourcePostData!.docRef = postData.reference;
        } else if (updateData.sourceType == 'requests') {
          updateData.toUsers.remove(currentUserId);
          updateData.fromUserData =
              await getUserProfileFirebase(updateData.toUsers[0]);
        }
        if (change.type == DocumentChangeType.added) {
          updateNotifications(updateData, 'added');
        } else if (change.type == DocumentChangeType.modified) {
          updateNotifications(updateData, 'modified');
        } else if (change.type == DocumentChangeType.removed) {
          updateNotifications(updateData, 'removed');
        }
      }
    });
  }
}
