import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/repository/batch_repo.dart';

class BatchApiProvider {
  final BatchRepo batchRepo;

  BatchApiProvider({required this.batchRepo});

  Future<ApiResponse> addNewBatch() async {
    ApiResponse apiResponse = await batchRepo.agrCreateBatch();
    return apiResponse;
  }
}
