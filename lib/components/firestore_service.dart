import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:premierchoixadmin/Models/InfoCategories.dart';
import 'package:premierchoixadmin/Models/commandes.dart';
import 'package:premierchoixadmin/Models/panier_classe.dart';
import 'package:premierchoixadmin/Models/produit.dart';
import 'package:premierchoixadmin/Models/produits_favoris_user.dart';
import 'package:premierchoixadmin/Models/tokens_utilisateurs.dart';
import 'package:premierchoixadmin/Models/utilisateurs.dart';

class FirestoreService {
  static final FirestoreService _firestoreService = FirestoreService
      ._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

 Future<void> addUtilisateur(Utilisateur utilisateur, String idDocument) {
    return _db.collection("Utilisateurs").document(idDocument).setData(utilisateur.toMap());
  }

  Future<void> addProducts(Produit produit, String categorie, String sousCategorie) {
    return _db.collection(categorie).document(sousCategorie).collection("Produits").add(produit.toMap());
  }

  Future<void> addProduitFavorisUser(ProduitsFavorisUser produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("ProduitsFavoirsUser").add(produit.toMap());
  }

  Future<void> addPanier(PanierClasse produit, String document, String id){
    return _db.collection("Utilisateurs").document(document).collection("Panier").document(id).setData(produit.toMap());
  }

  ///Ici on ajoute la commande de l'utilisateur dans ces commandes persos
  Future<void> addCommande(Commandes commande, String document,){
    return _db.collection("Utilisateurs").document(document).collection("Commandes").add(commande.toMap());
  }
  ///Fin de la fonction


  /// Ici on ajoute la commande de l'utilisateur chez l'admin
  Future<void> addCommandeToAdmin(Commandes commande, String document,){
    return _db.collection("Commandes").add(commande.toMap());
  }
  ///Fin de la fonction



  Future<void> addToken(Tokens tokens){
    return _db.collection("Tokens").add(tokens.toMap());
  }


  /* Récupération des catégories de la base de données*/
  Stream<List<Utilisateur>> getUtilisateurs() {
    return _db.collection("Utilisateurs").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Utilisateur.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }
/* Fin de la récupération des catégories de la base de données*/


/*Recuperation du produit*/
  Stream<List<Produit>> getProduit() {
    return _db.collection("produit").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Produit.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }


  Stream<List<InfoCategories>> getCategoriesHF(String nom) {
    return _db.collection(nom).snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => InfoCategories.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

  /*Récupération des sous_categories*/
  Stream<List<InfoCategories>> getSousCategories() {
    return _db.collection("sous-categories").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => InfoCategories.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

  /*Fin de la récupération*/

  Stream<List<ProduitsFavorisUser>> getProduitsFavorisUser(String id) {
    return _db.collection("Utilisateurs").document(id).collection("ProduitsFavoirsUser").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => ProduitsFavorisUser.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

  Stream<List<PanierClasse>> getProduitPanier(String id) {
    return _db.collection("Utilisateurs").document(id).collection("Panier").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => PanierClasse.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////////
  Stream<List<Produit>> getProduitFemmes() {
    return _db.collection("Femmes").document("CHAUSSURES").collection("Produits").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Produit.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

  Stream<List<Produit>> getProduitFemmes1() {
    return _db.collection("Femmes").document("CHAUSSURES").collection("Produits").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Produit.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }
  //////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> addFavoris(Produit produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("Favoris").add(produit.toMap());
  }

  Future<void> deleteFavoris(String document, String document1){
    return _db.collection("Utilisateurs").document(document)
        .collection("Favoris").document(document1).delete();
  }
  Future<void> deletePanier(String document, String document1){
    return _db.collection("Utilisateurs").document(document)
        .collection("Panier").document(document1).delete();
  }

  Future<void> addPanierSansId(PanierClasse produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("Panier").add(produit.toMap());
  }

  /// Cette fonction permettra de refuser à l'utilisateur d'ajouter des produits déjà ajouté dans le panier d'un autre utilisateur chez lui
  Future<void> produitsIndisponibles(PanierClasse produit){
    return _db.collection("ProduitsIndisponibles").add(produit.toMap());
  }

  Future<void> deleteProduitsIndisponibles( String document1){
    return _db.collection("ProduitsIndisponibles").document(document1).delete();
  }


  /// Fin de la fonction
  Stream<List<Produit>> getFavoris(String document) {
    return _db.collection("Utilisateurs").document(document).collection(
        "Favoris").snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Produit.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Stream<List<Commandes>> getCommandes(String id) {
    return _db.collection("Utilisateurs").document(id).collection("Commandes").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Commandes.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }


/* Fonction qui permet d'ajouter les variables spécifiques aux utilisateurs*/
/*Future<void> addProduitFavorisUser(ProduitsFavorisUser produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("ProduitsFavoirsUser").add(produit.toMap());
  }*/

  /*Future<void> addPanier(PanierClasse produit, String document, String id){
    return _db.collection("Utilisateurs").document(document).collection("Panier").document(id).setData(produit.toMap());
  }*/



  /*
  Stream<List<Produit>> getProduits(String titreCategorie) {
    return _db.collection(titreCategorie).snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Produit.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }



/*Récupération categories*/
Stream<List<InfoCategories>> getCategories() {
    return _db.collection("Catégories").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => InfoCategories.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }
  /*Fin de la récupération*/

/*Récupération des sous_categories*/
Stream<List<InfoCategories>> getSousCategories() {
    return _db.collection("sous-categories").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => InfoCategories.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }
  
  /*Fin de la récupération*/

/*Recuperation du produit*/
Stream<List<Produit>> getProduit() {
    return _db.collection("produit").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Produit.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

  Stream<List<ProduitsFavorisUser>> getProduitsFavorisUser(String id) {
    return _db.collection("Utilisateurs").document(id).collection("ProduitsFavoirsUser").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => ProduitsFavorisUser.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }

  Stream<List<PanierClasse>> getProduitPanier(String id) {
    return _db.collection("Utilisateurs").document(id).collection("Panier").snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => PanierClasse.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }



/* Fonction qui permet d'ajouter les variables spécifiques aux utilisateurs*/
Future<void> addProduitFavorisUser(ProduitsFavorisUser produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("ProduitsFavoirsUser").add(produit.toMap());
  }

  Future<void> addFavoris(Produit produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("Favoris").add(produit.toMap());
  }

  Future<void> deleteFavoris(String document, String document1){
    return _db.collection("Utilisateurs").document(document)
        .collection("Favoris").document(document1).delete();
  }

  Stream<List<Produit>> getFavoris(String document) {
    return _db.collection("Utilisateurs").document(document).collection(
        "Favoris").snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Produit.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Future<void> addPanier(PanierClasse produit, String document, String id){
    return _db.collection("Utilisateurs").document(document).collection("Panier").document(id).setData(produit.toMap());
  }


  Future<void> addPanierSansId(PanierClasse produit, String document){
    return _db.collection("Utilisateurs").document(document).collection("Panier").add(produit.toMap());
  }
  /*
  Stream<List<Produit>> getProduits(String titreCategorie) {
    return _db.collection(titreCategorie).snapshots().map(
          (snapshot) =>
          snapshot.documents.map(
                (doc) => Produit.fromMap(doc.data, doc.documentID),
          ).toList(),
    );
  }







Future<void> updateUtilisateur(String document, Utilisateur utilisateur){
    return _db.collection("Utilisateurs").document(document).updateData(utilisateur.toMap());
}



 

  /// Fonction pour ajouter les messages
   Future<void> addMessage(Messages messages){
    return _db.collection("Messages").document().setData((messages.toMap()));
   }

 /// Fonction pour obtenir les messages

 /* Stream<List<Messages>> getMessages(String document) {
    return _db.collection("Utilisateurs").document(document).collection(
        "Messages").snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Messages.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }*/


 /// Fonction pour l'ajout des favoris pour la vérification de l'etat ajout ou non des produits

  
 Stream<List<Favories>> getEtat(String document ) {
    return _db.collection("Utilisateurs").document(document).collection("EtatProduit").snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Favories.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }





  Future<void> updateEtatFavoris(String document, Favories favories){
    return _db.collection("Utilisateurs").document(document).updateData(favories.toMap());
  }








  Stream<List<Messages>> getMessages() {
    return _db.collection("Messages").snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => Messages.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }
*/*/
}
