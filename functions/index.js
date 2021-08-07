const functions = require("firebase-functions");
//  import * as admin from "firebase-admin";
const admin = require("firebase-admin");
admin.initializeApp();

// const db = admin.firestore();

/* const observer = query.onSnapshot((querySnapshot) => {
  console.log("Received query snapshot of size ${querySnapshot.size}");
}, (err) => {
  console.log("Encountered error: ${err}");
});
observer(); */
/* export const sendNotifications = functions.firestore.
    document("/users/nil/links").
    onCreate(async (snap, context) => {
      console.log("x", "y");
    }); */
/* exports.sendChatNotificationsSsSs = functions.firestore
    .document("/users/nil/links/EKDuwTa7pFgQyOgxDFbj")
    .onUpdate(async (threadSnapshot, context) => {
      console.log("x", "y");
    }); */
exports.bildirimSend = functions.https.onCall((token) => {
  console.log("başlanfic", token);
  const options = {
    priority: "high",
    timeToLive: 60 * 60 * 24,

  };
  const payload = {
    notification: {
      title: token.data.title,
      body: token.data.body,
      sound: "default",
    }};
  admin.messaging().sendToDevice(token.data.token, payload, options)
      .then((response) => {
        console.log("Successfully sent message:", token.data.token);
      })
      .catch((error) => {
        console.log("Error sending message:", error);
      });
  console.log("data", "noticifiasf");
});
