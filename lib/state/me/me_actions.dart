import 'package:crust/models/post.dart';
import 'package:crust/models/user.dart';
import 'package:crust/models/user_reward.dart';

class AddUserRequest {
  final User user;

  AddUserRequest(this.user);
}

class LoginSuccess {
  final User user;

  LoginSuccess(this.user);
}

class FetchMyPostsRequest {
  final int userId;

  FetchMyPostsRequest(this.userId);
}

class FetchMyPostsSuccess {
  final List<Post> posts;

  FetchMyPostsSuccess(this.posts);
}

class LogoutSuccess {}

class Logout {}

class FavoriteRewardRequest {
  final int rewardId;

  FavoriteRewardRequest(this.rewardId);
}

class FavoriteRewardSuccess {
  final Set<int> rewards;

  FavoriteRewardSuccess(this.rewards);
}

class UnfavoriteRewardRequest {
  final int rewardId;

  UnfavoriteRewardRequest(this.rewardId);
}

class UnfavoriteRewardSuccess {
  final Set<int> rewards;

  UnfavoriteRewardSuccess(this.rewards);
}

class FavoriteStoreRequest {
  final int storeId;

  FavoriteStoreRequest(this.storeId);
}

class FavoriteStoreSuccess {
  final Set<int> stores;

  FavoriteStoreSuccess(this.stores);
}

class UnfavoriteStoreRequest {
  final int storeId;

  UnfavoriteStoreRequest(this.storeId);
}

class UnfavoriteStoreSuccess {
  final Set<int> stores;

  UnfavoriteStoreSuccess(this.stores);
}

class FavoritePostRequest {
  final int postId;

  FavoritePostRequest(this.postId);
}

class FavoritePostSuccess {
  final Set<int> posts;

  FavoritePostSuccess(this.posts);
}

class UnfavoritePostRequest {
  final int postId;

  UnfavoritePostRequest(this.postId);
}

class UnfavoritePostSuccess {
  final Set<int> posts;

  UnfavoritePostSuccess(this.posts);
}

class FetchFavoritesRequest {
  final bool updateStore;

  FetchFavoritesRequest({this.updateStore: false});
}

class FetchFavoritesSuccess {
  final Set<int> favoriteRewards;
  final Set<int> favoriteStores;
  final Set<int> favoritePosts;

  FetchFavoritesSuccess({this.favoriteRewards, this.favoriteStores, this.favoritePosts});
}

class FetchUserRewardRequest {
  final int rewardId;

  FetchUserRewardRequest(this.rewardId);
}

class FetchUserRewardSuccess {
  final UserReward userReward;

  FetchUserRewardSuccess(this.userReward);
}

class AddUserRewardRequest {
  final int rewardId;

  AddUserRewardRequest(this.rewardId);
}
