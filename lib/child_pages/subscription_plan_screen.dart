import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final Color themeColor;
  const SubscriptionPlanScreen({
    super.key,
    required this.themeColor,
  });

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeColor,
        title: Text(
          "Subscription Plan",
          style: TextStyle(color: Color(0xffffffff)),
        ),
        iconTheme: IconThemeData(color: Color(0xffffffff)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: widget.themeColor.withOpacity(0.5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Choose your subscription plan",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.indigo),
                    textAlign: TextAlign.center,
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('subscription plans')
                      .orderBy('price',
                          descending: false) // Order by price ascending
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        if (!data.containsKey('name') ||
                            !data.containsKey('price') ||
                            !data.containsKey('duration') ||
                            !data.containsKey('features')) {
                          return SizedBox.shrink();
                        }
                        return _buildSubscriptionCard(
                          title: data['name'],
                          price: data['price'].toString(),
                          priceDuration: data['duration'],
                          features: List<String>.from(data['features']),
                          backgroundColor: Colors.white,
                          textColor: widget.themeColor,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    required String priceDuration,
    required List<String> features,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.8,
      // height: MediaQuery.of(context).size.height * 0.42,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 2, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: backgroundColor),
                      ),
                      Text(
                        priceDuration,
                        style: TextStyle(fontSize: 12, color: backgroundColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map(
                    (feature) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: widget.themeColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            feature,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor,
              foregroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
