import 'package:flutter/cupertino.dart';
import 'package:number_trivia_mvvm/home/repository/home_repo.dart';
import 'package:number_trivia_mvvm/home/view_model/loading_state.dart';

import '../../failure.dart';

class HomeViewModel extends ChangeNotifier {
  
  HomeRepository homeRepository;
  HomeViewModel({required this.homeRepository});

  String serverFailureMessage = 'Server Failure';
  String cacheFailureMessage = 'Cache Failure';

  LoadingState loadingState = InitialState();
  
  Future<void> getConcreteNumberTrivia(int number) async {
    loadingState = InProgress();
    notifyListeners();
    final failureOrTrivia = await homeRepository.getConcreteNumberTrivia(number);
    failureOrTrivia.fold((failure) {
      loadingState = Error(message: _mapFailureToMessage(failure));
      notifyListeners();
    }, (trivia) {
      loadingState = Completed(data: trivia.text);
      notifyListeners();
    });
  }

  Future<void> getRandomNumberTrivia() async {
    loadingState = InProgress();
    notifyListeners();
    final failureOrTrivia =
        await homeRepository.getRandomNumberTrivia();
    failureOrTrivia.fold((failure) {
      loadingState = Error(message: _mapFailureToMessage(failure));
      notifyListeners();
    }, (trivia) {
      loadingState = Completed(data: trivia.text);
      notifyListeners();
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return serverFailureMessage;
    } else {
      return cacheFailureMessage;
    }
  }
}
