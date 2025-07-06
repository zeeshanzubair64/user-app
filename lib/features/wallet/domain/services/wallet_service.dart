import 'package:flutter_sixvalley_ecommerce/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/domain/services/wallet_service_interface.dart';

class WalletService implements WalletServiceInterface{
  WalletRepositoryInterface walletRepositoryInterface;

  WalletService({required this.walletRepositoryInterface});

  @override
  Future addFundToWallet(String amount, String paymentMethod) async{
    return await walletRepositoryInterface.addFundToWallet(amount, paymentMethod);
  }

  @override
  Future getWalletBonusBannerList() async{
    return await walletRepositoryInterface.getWalletBonusBannerList();
  }

  // @override
  // Future getWalletTransactionList(int offset, String types, String startDate, String endDate, String filterByType) async{
  //   return await walletRepositoryInterface.getWalletTransactionList(offset, types, startDate, endDate, filterByType);
  // }

  @override
  Future getList({
    int? offset = 1,
    String? filterBy,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? transactionTypes,
  }) async{
    return walletRepositoryInterface.getList(offset: offset, startDate: startDate, endDate: endDate, transactionTypes: transactionTypes, filterBy: filterBy);
  }

}