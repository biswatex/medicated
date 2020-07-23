var firebaseConfig = {
  apiKey: "AIzaSyB7IB3ZqH0J4XFaeEQJ6GCKQTHMxpP281g",
  authDomain: "medicated-76702.firebaseapp.com",
  databaseURL: "https://medicated-76702.firebaseio.com",
  projectId: "medicated-76702",
  storageBucket: "medicated-76702.appspot.com",
  messagingSenderId: "865126600281",
  appId: "1:865126600281:web:7164e8b562a2f7b173ab48",
  measurementId: "G-S2MKJE692R"
};
firebase.initializeApp(firebaseConfig);
defaultStorage = firebase.storage();
defaultFirestore = firebase.firestore()