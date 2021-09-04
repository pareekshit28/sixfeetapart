import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixfeetapart/viewmodels/homescreenviewmodel.dart';
import 'package:sixfeetapart/viewmodels/settingsscreenviewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SettingsScreenViewModel>(context, listen: false).getWhiteList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsScreenViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: viewModel.whiteList != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "WhiteListed Devices",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.whiteList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(viewModel.whiteList!.elementAt(index)),
                          trailing: MaterialButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(4)),
                            onPressed: () async {
                              var res = await viewModel.removeFromWhiteList(
                                  viewModel.whiteList!.elementAt(index));

                              if (res) {
                                Provider.of<SettingsScreenViewModel>(context,
                                        listen: false)
                                    .getWhiteList();
                                Provider.of<HomeScreenViewModel>(context,
                                        listen: false)
                                    .getDevicesList(true);
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.remove),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Remove"),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
