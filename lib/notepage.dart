

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _namecontroller1 = TextEditingController();
  final TextEditingController _pricecontroller1 = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  Future<void> _create() async {
  await showModalBottomSheet(
  isScrollControlled: true,
  context: context,
  builder: (BuildContext context) {
  return Padding(
  padding: EdgeInsets.only(
  top: 20,
  left: 20,
  right: 20,
  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize: MainAxisSize.min,
  children: [
  const SizedBox(
  height: 20,
  ),
  const Text(
  "Add Items",
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
  ),
  const SizedBox(
  height: 20,
  ),
  TextField(
  controller: _namecontroller1,
  decoration: const InputDecoration(labelText: "Name"),
  ),
  TextField(
  controller: _pricecontroller1,
  decoration: const InputDecoration(labelText: "Price"),
  ),
  const SizedBox(
  height: 20,
  ),
  ElevatedButton(
  onPressed: () async{
  final String name = _namecontroller1.text;
  final int? price = int.tryParse(_pricecontroller1.text);
  if(price!=null)
  {
  await item.add({'name': name, 'price':price});
  _namecontroller1.text = '';
  _pricecontroller1.text = '';
  Navigator.of(context).pop();
  }
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.redAccent),
  child: const Text('Create'))
  ],
  ),
  );
  });
  }
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async{
  if(documentSnapshot !=null)
  {
  _namecontroller.text = documentSnapshot['name'];
  _pricecontroller.text = documentSnapshot['price'].toString();
  }
  {
  await showModalBottomSheet(
  isScrollControlled: true,
  context: context,
  builder: (BuildContext context) {
  return Padding(
  padding: EdgeInsets.only(
  top: 20,
  left: 20,
  right: 20,
  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  mainAxisSize: MainAxisSize.min,
  children: [
  const SizedBox(
  height: 20,
  ),
  const Text(
  "Update",
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
  ),
  const SizedBox(
  height: 20,
  ),
  TextField(
  controller: _namecontroller,
  decoration: const InputDecoration(labelText: "Name"),
  ),
  TextField(
  controller: _pricecontroller,
  decoration: const InputDecoration(labelText: "Price"),
  ),
  const SizedBox(
  height: 20,
  ),
  ElevatedButton(
  onPressed: () async{
  final String name = _namecontroller.text;
  final int? price = int.tryParse(_pricecontroller.text);
  if(price!=null)
  {
  await item.doc(documentSnapshot!.id).update({"name": name, "price":price});
  _namecontroller.text = '';
  _pricecontroller.text = '';
  Navigator.of(context).pop();
  }
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: Colors.redAccent),
  child: const Text('Update'))
  ],
  ),
  );
  });
  }
  }
  Future<void> _delete(String productId) async{
  await item.doc(productId).delete();
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  backgroundColor: Colors.redAccent,
  content: Text('You have Successfully deleted an item')));
  }

  final CollectionReference item =
  FirebaseFirestore.instance.collection('Stationery');


  @override
  Widget build(BuildContext context) {
    Future<void> _calculateTotalPrice() async{
      QuerySnapshot querySnapshot = await item.get();
      int totalPrice = 0;
      querySnapshot.docs.forEach((itprice)
      {
        totalPrice = totalPrice + (itprice['price'] as num).toInt();
      }
      );
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Total Price"),
              content: Text('\u{20B9}${totalPrice.toInt()}'),
              actions: [
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Close'),),
              ],
            );
          }
      );
    }

  return Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.redAccent,
  title: const Text('Stationary Items'),
  centerTitle: true,
  ),
  body: Padding(
  padding: const EdgeInsets.only(left: 10, right: 10),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Expanded(
  flex: 8,
  child: StreamBuilder(
  stream: item.snapshots(),
  builder:
  (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
  if (streamSnapshot.hasData) {
  return ListView.builder(
  itemCount: streamSnapshot.data!.docs.length,
  itemBuilder: (context, index) {
  final DocumentSnapshot documentSnapshot =
  streamSnapshot.data!.docs[index];
  return Card(
  margin: const EdgeInsets.all(10),
  child: ListTile(
  title: Text(
  documentSnapshot['name'],
  style: const TextStyle(
  fontWeight: FontWeight.w600, fontSize: 17),
  ),
  subtitle: Text(
  '\u{20B9}${(documentSnapshot['price']).toString()}',
  style: const TextStyle(
  fontSize: 15, fontWeight: FontWeight.w500),
  ),
  trailing: SizedBox(
  width: 100,
  child: Row(
  children: [
  IconButton(
  onPressed: () {
  _update(documentSnapshot);
  },
  icon: const Icon(Icons.edit,color: Colors.yellow,)),
  IconButton(
  onPressed: () {
  _delete(documentSnapshot.id);
  },
  icon: const Icon(Icons.delete,color: Colors.red,)),
  ],
  ),
  ),
  ),
  );
  });
  }
  return const Center(
  child: CircularProgressIndicator(),
  );

  },
  ),
  ),
  Expanded(child: Container(
  child: TextButton(
  onPressed: (){
  _calculateTotalPrice();
  },
  child: Text('Total',style: TextStyle(fontSize: 24,color: Colors.redAccent),),
  ),
  ))
  ],
  ),
  ),
  floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.redAccent,
  onPressed: () {
  _create();
  },
  child: const Icon(Icons.add),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
  }
}
