import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/home_view_model.dart';
import '../view_model/loading_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late HomeViewModel homeViewModel;
  String inputStr = "";

  @override
  void initState() {
    super.initState();
    homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<HomeViewModel>(builder: (context, model, _) {
              if (model.loadingState is InitialState) {
                return const Padding(
                  padding: EdgeInsets.  all(8.0),
                  child: Text("Start Searching"),
                );
              } else if (model.loadingState is InProgress) {
                return const CircularProgressIndicator();
              } else if (model.loadingState is Completed) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.loadingState.props.single.toString()),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(model.loadingState.props.single.toString()),
                );
              }
            }),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Input a number',
                ),
                onChanged: (value) {
                  inputStr = value;
                },
                onSubmitted: (_) {
                  dispatchConcrete();
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: dispatchConcrete,
                    child: const Text('Search'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: dispatchRandom,
                    child: const Text('Get random trivia'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void dispatchConcrete() {
    if (inputStr.isEmpty) {
      SnackBar snackBar = const SnackBar(content: Text("Kindly enter a valid value."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    homeViewModel.getConcreteNumberTrivia(int.parse(inputStr));
  }

  void dispatchRandom() {
    homeViewModel.getRandomNumberTrivia();
  }
}