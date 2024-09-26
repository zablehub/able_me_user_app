import 'package:able_me/models/transaction/transaction_order.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/api/transaction/transaction_api.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _transactionApi =
    StateProvider<TransactionApi>((ref) => TransactionApi());

final ongoingTransactionsProvider = FutureProvider<List<TransactionOrder>>(
    (ref) async => await ref.read(_transactionApi).getOngoingTransactions());

final allTransactionsProvider = FutureProvider<List<TransactionOrder>>(
  (ref) async {
    final UserModel? _currentUser = ref.read(currentUser);
    if (_currentUser == null) return [];
    return await ref
        .read(_transactionApi)
        .getTransactionHistory(myID: _currentUser.id);
  },
);
