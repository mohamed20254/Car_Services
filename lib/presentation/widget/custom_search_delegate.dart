import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/logic/cubit/fav_cubit.dart';
import 'package:ecommerce_app/logic/cubit/search_cubit.dart';
import 'package:ecommerce_app/model/fav_model.dart';
import 'package:ecommerce_app/model/get_all_prudict.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    searchCubit.search(query);

    return BlocBuilder<SearchCubit, List<PrudctModel>>(
      builder: (context, filteredItems) {
        if (filteredItems.isEmpty) {
          return Center(child: Text("لا توجد نتائج"));
        }
        return GridView.builder(
          shrinkWrap: true,
          //   physics: NeverScrollableScrollPhysics(),
          itemCount: filteredItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 220,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            FavModel item = FavModel(
              id: index,
              name: filteredItems[index].title,
              img: filteredItems[index].img,
            );
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.prudicDetils,
                  arguments: filteredItems[index],
                );
              },
              child: Card(
                color: Colors.white,

                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: () {
                              context.read<FavCubit>().addFav(item, context);
                            },
                            child: BlocBuilder<FavCubit, List<FavModel>>(
                              builder: (context, state) {
                                final isfavorit = state.contains(item);
                                return Icon(
                                  isfavorit
                                      ? Icons.favorite
                                      : Icons.favorite_border_rounded,

                                  color: Colors.red,
                                  size: 27,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: CachedNetworkImage(
                          height: 80,
                          imageUrl: filteredItems[index].img,
                          placeholder:
                              (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                          errorWidget:
                              (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${filteredItems[index].title.substring(0, 15)}...",
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            "${S.of(context).price} : ${filteredItems[index].price} ",
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            "EGP",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 232, 138, 24),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 55, 160, 247),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
