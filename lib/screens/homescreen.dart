import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:sixfeetapart/components/far.dart';
import 'package:sixfeetapart/components/near.dart';
import 'package:sixfeetapart/components/scanning.dart';
import 'package:sixfeetapart/screens/settingsscreen.dart';
import 'package:sixfeetapart/viewmodels/homescreenviewmodel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PanelController();
  late Timer bleTimer;
  bool scanning = true;
  final homeScreenViewModel = HomeScreenViewModel();

  @override
  void initState() {
    super.initState();
    Provider.of<HomeScreenViewModel>(context, listen: false)
        .getDevicesList(false);

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        scanning = false;
      });
    });
    bleTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      setState(() {
        scanning = true;
      });
      Provider.of<HomeScreenViewModel>(context, listen: false)
          .getDevicesList(false);
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          scanning = false;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    homeScreenViewModel.stopScan();
    bleTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenViewModel>(
        builder: (context, viewModel, child) => Scaffold(
            backgroundColor: Colors.white,
            body: viewModel.list != null
                ? SlidingUpPanel(
                    controller: controller,
                    panel: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              height: 3,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(28)),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SettingsScreen()));
                                  }),
                              Text("6 feet apart",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500)),
                              IconButton(
                                  icon: Icon(Icons.smartphone_outlined),
                                  onPressed: () {
                                    controller.isPanelOpen
                                        ? controller.close()
                                        : controller.open();
                                  }),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  "Devices Nearby",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: viewModel.list!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(viewModel.list!
                                                  .elementAt(index)
                                                  .device
                                                  .name !=
                                              ""
                                          ? viewModel.list!
                                              .elementAt(index)
                                              .device
                                              .name
                                          : viewModel.list!
                                              .elementAt(index)
                                              .device
                                              .id
                                              .id),
                                      trailing: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        onPressed: () async {
                                          var res = await viewModel
                                              .addToWhiteList(viewModel.list!
                                                  .elementAt(index)
                                                  .device
                                                  .id
                                                  .id);

                                          if (res) {
                                            Provider.of<HomeScreenViewModel>(
                                                    context,
                                                    listen: false)
                                                .getDevicesList(true);
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("WhiteList"),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                    minHeight: 80,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                    body: Container(
                        color: scanning
                            ? Colors.grey
                            : viewModel.list!.length > 0
                                ? Colors.red
                                : Colors.green,
                        child: Center(
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 150,
                              child: scanning
                                  ? Scanning()
                                  : viewModel.list!.length > 0
                                      ? Near()
                                      : Far()),
                        )),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
