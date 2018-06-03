//for google calendar integration
const fs = require('fs');
const readline = require('readline');
const { google } = require('googleapis');

//send a mail with purchase details
const nodemailer = require('nodemailer');

//firebase initialisation
//firebase webhook url for the project is : https://us-central1-labonneliste-ef07b.cloudfunctions.net/webhook
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
var firestore = admin.firestore();

//Dialogflow 
const {
    dialogflow,
    Permission,
    Place,
    SignIn
} = require('actions-on-google');


// Instantiate the Dialogflow client.
const app = dialogflow({ debug: true });

const doc1 = (doc) => {
    if (!doc.exists) {
        console.log('pas trouvé !');

    } else {
        var add_details = doc.data();
        titre_annonce = add_details.name;

        console.log('Document data:', add_details);


        return titre_annonce;

    }
}

const startCall = () => {
    var babyRef = firestore.collection('baby').doc('dana');
    return babyRef.update(
        {
            status: 'appel en cours...'
        }
    )
}

app.intent('Default Welcome Intent', conv => {
    return startCall()
        .then((value) => {

            //console.log(value)
            conv.ask(`appel d'un acheteur en cours : `)
        });
});

const getSellerData = () => {
    var babyRef = firestore.collection('baby').doc('dana');
    return babyRef.get()
};

app.intent('liste-achats', conv => {
    return getSellerData()
        .then((value) => {

            console.log(value)
            conv.ask(`Allo, je vous contacte au sujet de l'annonce ${value.data().name}. Est-elle disponible ? Mon client est prêt à mettre ${value.data().votes} euros`)
        });
});

const updateSellerStatus = () => {
    var babyRef = firestore.collection('baby').doc('dana');
    return babyRef.update(
        {
            disponible: false,
            status: 'refusé',
        }
    )
};

app.intent('liste-achats - no', conv => {
    return updateSellerStatus()
        .then((value) => {

            //console.log(value)
            conv.ask(`Tant pis ! N'oubliez pas de désactiver votre annonce !`)
        });
});


app.intent('liste-achats - yes', (conv) => {
    conv.ask('Parfait ! Pouvons-nous nous rencontrer dans le 12ème arrondissement ?');
});

app.intent('liste-achats - yes - custom', (conv, params) => {
    var babyRef = firestore.collection('baby').doc('dana');
    babyRef.update(
        {
            address: params['street-address']
        }
    )
    console.log(params['street-address']);
    conv.ask('Cette addresse convient à mon client ! Ok pour demain 18h ?');
});



const getFinalData = () => {
    var babyRef = firestore.collection('baby').doc('dana');
    return babyRef.get()
};

app.intent('liste-achats - yes - custom - yes', conv => {
    return getSellerData()
        .then((value) => {

            console.log(value)
            conv.close(` Parfait ! Lucas vous rappellera pour confirmer le rendez vous demain 18h, au ${value.data().address} pour ${value.data().votes} euros`)
            var babyRef = firestore.collection('baby').doc('dana');
            babyRef.update(
                {
                    status: 'rdv fixé'
                }
            );
        });
});

app.intent('location_helper', (conv) => {
    console.log('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
    conv.ask(new SignIn('To get your account details'))
});

app.intent('ask_for_place_confirmation', (conv, params, signin) => {
    if (signin.status === 'OK') {
      const payload = conv.user.profile.payload
      
      console.log('+------------------------------------------------------------------------------------------------------------------------')
      console.log('c est la ' + payload)
      
      conv.ask(`I got your account details, ${payload.name}. What do you want to do next?`)
    } else {
      conv.ask(`I won't be able to save your data, but what do you want to do next?`)
    }
  })

    // Set the DialogflowApp object to handle the HTTPS POST request.
    exports.webhook = functions.https.onRequest(app);








// // create reusable transporter object using the default SMTP transport
// let transporter = nodemailer.createTransport({
//     //  host: 'smtp.ethereal.email',
//     //  port: 587,
//     service: 'Gmail',

//     //secure: false, // true for 465, false for other ports
//     auth: {
//         user: 'yannis.achour@gmail.com', // generated ethereal user
//         pass: 'xxx' // generated ethereal password
//     }
// });

// // setup email data with unicode symbols
// let mailOptions = {
//     from: '"Le Bon Broker" <yannis.achour@gmail.com>', // sender address
//     to: 'yachour@nuxeo.com', // list of receivers
//     subject: 'Génial ! vos baskets vous attendent ', // Subject line
//     text: 'Hello world?', // plain text body
//     html: '<b>Hello world?</b>' // html body
// };

// exports.webhook = functions.https.onRequest((request, response) => {

//     //get some data from firestore and use it to tell something in dialogflow
//     var babyRef = firestore.collection('baby').doc('dana');
//     var getDoc = babyRef.get()
//         .then(doc => {
//             if (!doc.exists) {
//                 console.log('pas trouvé !');
//                 response.send(
//                     {
//                         fulfillmentText: "doc n'existe pas"
//                     }
//                 );
//             } else {
//                 var name_votes = doc.data();

//                 console.log('Document data:', name_votes);
//                 // send mail with defined transport object


//                 // send mail with defined transport object
//                 transporter.sendMail(mailOptions, (error, info) => {
//                     if (error) {
//                         return console.log(error);
//                     }
//                     console.log('Message sent: %s', info.messageId);
//                     // Preview only available when sending through an Ethereal account
//                     console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));

//                     // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>
//                     // Preview URL: https://ethereal.email/message/WaQKMgKddxQDoou...
//                 });



//                 response.send(
//                     {

//                         //fulfillmentText: `J'ai trouvé son petit nom, c'est ${name_votes.name} qui a ${name_votes.votes} votes !`
//                         fulfillmentText: '<speak>'
//                             + 'je peux faire un gros bruit !'
//                             + '<audio src="https://actions.google.com/sounds/v1/alarms/beep_short.ogg">a digital watch alarm</audio>'
//                             + 'puis dire quelque chose'
//                             + '<audio src="https://actions.google.com/sounds/v1/alarms/beep_short.ogg">a digital watch alarm</audio>'
//                             + `J'ai trouvé son petit nom, c'est ${name_votes.name} qui a ${name_votes.votes} votes !`
//                             + '</speak>'

//                     }
//                 );
//             }
//         })
//         .catch(err => {
//             console.log('Error getting document', err);
//             response.send(
//                 {
//                     fulfillmentText: "ya un truc qui a raté dans la BDD"
//                 }
//             );
//         });
// });












// function bookAppointment(app) { 
//       googleRequest(app, createEvent);
//     }




//to be removed if committed !!!

//Google calendar api integration credentials
//clientid
//482137896343-18hgdnak3753ugtonnm36u1jce2tj2e1.apps.googleusercontent.com
//secret
//Lm35LXydxWzqM1K2_ivHtpxN

//firebase project credentials : 
// <script src="https://www.gstatic.com/firebasejs/5.0.3/firebase.js"></script>
// <script>
//   // Initialize Firebase
//   var config = {
//     apiKey: "AIzaSyDViJQ3IApdYY6dfuc9FZkMmZl786SIRVk",
//     authDomain: "labonneliste-ef07b.firebaseapp.com",
//     databaseURL: "https://labonneliste-ef07b.firebaseio.com",
//     projectId: "labonneliste-ef07b",
//     storageBucket: "labonneliste-ef07b.appspot.com",
//     messagingSenderId: "482137896343"
//   };
//   firebase.initializeApp(config);
// </script>