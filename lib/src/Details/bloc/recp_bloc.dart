import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project6/src/Details/bloc/recp_event.dart';
import 'package:project6/src/Details/bloc/recp_state.dart';

class RecpBloc extends Bloc<RecpEvent, RecpState> {
  RecpBloc() : super(RecpInitial()) {
    on<UpdateRecipeEvent>(_onUpdateRecipe);
  }

  void _onUpdateRecipe(UpdateRecipeEvent event, Emitter<RecpState> emit) {
    emit(RecipeUpdatedState(
      title: event.updatedTitle,
      description: event.updatedDescription,
    ));
  }
}

