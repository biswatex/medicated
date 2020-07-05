import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:medicated/components/CategoryCard.dart';
import 'package:medicated/components/DoctorType.dart';
import 'package:medicated/components/PathologyCard.dart';
import 'package:medicated/components/card.dart';
import 'package:medicated/components/mainAppBar.dart';

class TabHome extends StatefulWidget {
  @override
  _TabHomeState createState() => _TabHomeState();

}

class _TabHomeState extends State<TabHome>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 25),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
  List items = [
    DoctorType(
      color_1: Colors.blue,
      color_2: Colors.pink,
      image: "https://www.rnz.co.nz/assets/news_crops/85269/eight_col_medicine.jpg?1565217199",
      title: "Allopathy",
      subtitle: "Discription",),
    DoctorType(
      color_1: Colors.green,
      color_2: Colors.blue,
      image: "https://t3.ftcdn.net/jpg/02/45/77/62/240_F_245776292_KjTmy7E9bYhpZxfikW1YLbZrG2EPoRay.jpg",
      title: "Ayurvedic",
      subtitle: "Discription",),
    DoctorType(
      color_1: Colors.pink,
      color_2: Colors.yellow,
      image: "https://img.freepik.com/free-photo/homeopathy-herbal-extracts-small-bottles_73944-9320.jpg?size=626&ext=jpg",
      title: "Homeopathy ",
      subtitle: "Discription",
    ),
  ];
  @override
  Widget build(BuildContext context)  {
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap:true,
          children: <Widget>[
            MainAppBar(),
            Padding(
              padding: const EdgeInsets.all(0),
              child: GFListTile(
                icon: Text("view all", style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Museo',
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),),
                avatar: Icon(Icons.category,color: Colors.grey,),
                title: Text('Category', style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Museo',
                  fontSize: 16,
                  color: Colors.black54,
                ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:MediaQuery.of(context).size.height*0.35,
                  child: CategoryCard()),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: GFListTile(
                avatar: Icon(Icons.find_in_page,color: Colors.grey,),
                title: Text('FindBy Type', style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Museo',
                  fontSize: 16,
                  color: Colors.black54,
                ),),
              ),
            ),
            CarouselSlider.builder(
                itemBuilder: (BuildContext context, int itemIndex) =>
                    Container(
                      child: items[itemIndex],
                    ),
                itemCount: 3,
                options: CarouselOptions(
                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  initialPage: 2,
                  enableInfiniteScroll: true,
                  reverse: true,
                  autoPlay: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                )
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: GFListTile(
                icon: Text("view all", style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Museo',
                  fontSize: 12,
                  color: Colors.blueGrey,
                ),),
                avatar: Icon(Icons.location_on,color: Colors.grey,),
                title: Text('Nearby Doctors', style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Museo',
                  fontSize: 16,
                  color: Colors.black54,
                ),),
              ),
            ),
            Container(
                child: DoctorsCard(),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Pathology', style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Museo',
                fontSize: 16,
                color: Colors.black54,
              ),),
            ),
            PathologyCard(),
            Container(
              padding: EdgeInsets.all(2),
              child: GFCard(
                boxFit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                imageOverlay: AssetImage('assets/images/physio.png'),
                title: GFListTile(
                  title: Text('Physiology',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  subTitle: Text('subtitle',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
                content: Text("Card description form server",style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),
                buttonBar: GFButtonBar(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  GFButton(
                    onPressed: () {},
                    text: 'View',
                  )
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}