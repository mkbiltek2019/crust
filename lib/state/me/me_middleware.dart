import 'package:crust/models/post.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMeMiddleware([MeService meService = const MeService(), PostService postService = const PostService()]) {
  final addUser = _addUser(meService);
  final fetchMyPosts = _fetchMyPosts(postService);
  final favoriteReward = _favoriteReward(meService);
  final unfavoriteReward = _unfavoriteReward(meService);
  final favoriteStore = _favoriteStore(meService);
  final unfavoriteStore = _unfavoriteStore(meService);
  final favoritePost = _favoritePost(meService);
  final unfavoritePost = _unfavoritePost(meService);
  final fetchFavorites = _fetchFavorites(meService);
  final fetchUserReward = _fetchUserReward(meService);
  final addUserReward = _addUserReward(meService);

  return [
    TypedMiddleware<AppState, AddUserRequest>(addUser),
    TypedMiddleware<AppState, FetchMyPostsRequest>(fetchMyPosts),
    TypedMiddleware<AppState, FavoriteRewardRequest>(favoriteReward),
    TypedMiddleware<AppState, UnfavoriteRewardRequest>(unfavoriteReward),
    TypedMiddleware<AppState, FavoriteStoreRequest>(favoriteStore),
    TypedMiddleware<AppState, UnfavoriteStoreRequest>(unfavoriteStore),
    TypedMiddleware<AppState, FavoritePostRequest>(favoritePost),
    TypedMiddleware<AppState, UnfavoritePostRequest>(unfavoritePost),
    TypedMiddleware<AppState, FetchFavoritesRequest>(fetchFavorites),
    TypedMiddleware<AppState, FetchUserRewardRequest>(fetchUserReward),
    TypedMiddleware<AppState, AddUserRewardRequest>(addUserReward),
  ];
}

Middleware<AppState> _addUser(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.addUser(action.me).then((userId) {
      store.dispatch(LoginSuccess(action.me.copyWith(id: userId)));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _fetchMyPosts(PostService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchMyPosts(action.userId).then(
      (posts) {
        store.dispatch(FetchMyPostsSuccess(posts));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _favoriteReward(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.favoriteReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((rewards) {
      store.dispatch(FavoriteRewardSuccess(rewards));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _unfavoriteReward(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.unfavoriteReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((rewards) {
      store.dispatch(UnfavoriteRewardSuccess(rewards));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _favoriteStore(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.favoriteStore(userId: store.state.me.user.id, storeId: action.storeId).then((stores) {
      store.dispatch(FavoriteStoreSuccess(stores));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _unfavoriteStore(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.unfavoriteStore(userId: store.state.me.user.id, storeId: action.storeId).then((stores) {
      store.dispatch(UnfavoriteStoreSuccess(stores));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _favoritePost(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.favoritePost(userId: store.state.me.user.id, postId: action.postId).then((posts) {
      store.dispatch(FavoritePostSuccess(posts));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _unfavoritePost(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.unfavoritePost(userId: store.state.me.user.id, postId: action.postId).then((posts) {
      store.dispatch(UnfavoritePostSuccess(posts));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _fetchFavorites(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (store.state.me.user != null) {
      service.fetchFavorites(store.state.me.user.id).then((map) {
        List<Reward> rewards = map['rewards'];
        List<MyStore.Store> stores = map['stores'];
        List<Post> posts = map['posts'];
        store.dispatch(FetchFavoritesSuccess(
            favoriteRewards: rewards.map((r) => r.id).toSet(),
            favoriteStores: stores.map((s) => s.id).toSet(),
            favoritePosts: posts.map((p) => p.id).toSet()));
        if (action.updateStore) {
          store.dispatch(FetchRewardsSuccess(rewards));
          store.dispatch(FetchStoresSuccess(stores));
        }
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _fetchUserReward(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (store.state.me.user != null) {
      service.fetchUserReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((userReward) {
        store.dispatch(FetchUserRewardSuccess(userReward));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _addUserReward(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (store.state.me.user != null) {
      service.addUserReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((userReward) {
        store.dispatch(FetchUserRewardSuccess(userReward));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}
