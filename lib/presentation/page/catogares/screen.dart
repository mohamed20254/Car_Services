import 'package:ecommerce_app/core/Routes/app_routes.dart';
import 'package:ecommerce_app/generated/l10n.dart';
import 'package:ecommerce_app/logic/bloc/fatch_data_screen_bloc/bloc/screen_bloc.dart';
import 'package:ecommerce_app/model/fav_model.dart';
import 'package:ecommerce_app/presentation/widget/grad_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Screen extends StatelessWidget {
  const Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    S.of(context).screens,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              BlocBuilder<ScreenBloc, ScreenState>(
                builder: (context, state) {
                  if (state is LoidingStatescreen) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is LoadedStatescreen) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.prudictList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 220,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        FavModel item = FavModel(
                          id: index,
                          name: state.prudictList[index].title,
                          img: state.prudictList[index].img,
                        );
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.prudicDetils,
                              arguments: state.prudictList[index],
                            );
                          },
                          child: Customcard(
                            price: state.prudictList[index].price,
                            title: state.prudictList[index].title,
                            img: state.prudictList[index].img,

                            item: item,
                          ),
                        );
                      },
                    );
                  } else if (state is ErrorStatescreen) {
                    return Text(
                      S.of(context).problem,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(),
                    child: Text(" ", style: TextStyle(color: Colors.indigo)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
