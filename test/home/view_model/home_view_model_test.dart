import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_mvvm/failure.dart';
import 'package:number_trivia_mvvm/home/entities/number_trivia.dart';
import 'package:number_trivia_mvvm/home/repository/home_repo.dart';
import 'package:number_trivia_mvvm/home/view_model/home_view_model.dart';
import 'package:number_trivia_mvvm/home/view_model/loading_state.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockHomeRepository;
  late HomeViewModel homeViewModel;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    homeViewModel = HomeViewModel(homeRepository: mockHomeRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: "text");
  final failure = ServerFailure();
  final cacheFailure = CacheFailure();

  group("get Number Trivia", () {
    test("should return number trivia for a given Number from the repository and loading state should be completed", () async {
      //arrange
      when(() => mockHomeRepository.getConcreteNumberTrivia(any())).thenAnswer((_) async {
        return right(tNumberTrivia);
      });

      //act
      await homeViewModel.getConcreteNumberTrivia(tNumber);

      //assert
      expect(homeViewModel.loadingState, Completed(data: tNumberTrivia.text));
      verify(() => mockHomeRepository.getConcreteNumberTrivia(any()));
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test("should return a Failure and loading state should be Error state", () async {
      //arrange
      when(() => mockHomeRepository.getConcreteNumberTrivia(any())).thenAnswer((_) async {
        return left(failure);
      });

      //act
      await homeViewModel.getConcreteNumberTrivia(tNumber);

      //assert
      expect(homeViewModel.loadingState, Error(message: homeViewModel.serverFailureMessage));
      verify(() => mockHomeRepository.getConcreteNumberTrivia(any()));
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });

  group("Get random number trivia", () {
    test("should return number trivia randomly from the repository", () async {
      //arrange
      when(() => mockHomeRepository.getRandomNumberTrivia()).thenAnswer((_) async => right(tNumberTrivia));

      //act
      await homeViewModel.getRandomNumberTrivia();

      //assert
      expect(homeViewModel.loadingState, Completed(data: tNumberTrivia.text));
      verify(() => mockHomeRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test("should return cache failure", () async {
      //arrange
      when(() => mockHomeRepository.getRandomNumberTrivia()).thenAnswer((_) async => left(cacheFailure));

      //act
      await homeViewModel.getRandomNumberTrivia();

      //assert
      expect(homeViewModel.loadingState, Error(message: homeViewModel.cacheFailureMessage));
      verify(() => mockHomeRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });
}