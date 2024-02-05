import '../../models/service_num_model.dart';
import '../../models/service_num_model_old.dart';

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<ActualiteA> items;

  ItemsLoaded({required this.items});
}

class ItemsError extends ItemsState {
  final String message;

  ItemsError({required this.message});
}

class ItemsSorted extends ItemsState {
  final String sortBy;
  final List<ServiceNumOld> sortedItems;

  ItemsSorted(this.sortBy, this.sortedItems);
}

class ItemsFiltered extends ItemsState {
  final String filter;
  final List<ServiceNumOld> filteredItems;

  ItemsFiltered(this.filter, this.filteredItems);
}
