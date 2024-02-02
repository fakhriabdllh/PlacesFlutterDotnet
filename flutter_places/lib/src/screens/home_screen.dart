// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/src/data/data_provider.dart';
import 'package:flutter_places/src/models/places_model.dart';
import 'package:flutter_places/src/screens/detail_screen.dart';
import 'package:flutter_places/src/screens/store_place_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var size = MediaQuery.of(context).size;
    AsyncValue<List<PlacesModel>> data = ref.watch(getPlacesDataProvider);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 20),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(getPlacesDataProvider);
        },
        child: Consumer(builder: (context, ref, child) {
          return data.when(
              data: (data) {
                List<PlacesModel> placesList = data;
                return SafeArea(
                  child: Stack(
                    children: [
                      ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                            id: data[index].id,
                                          )),
                                );
                              },
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: SizedBox(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          placesList[index].placeName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width: size.width,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: CachedNetworkImage(
                                          imageUrl: placesList[index].imageUrl,
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.grey,
                                                    ),
                                                  )),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 100),
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.error,
                                                    size: 30,
                                                    color: Colors.grey[400],
                                                  )),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              size: 20,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                placesList[index].address,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ]),
                              ),
                            );
                          }),
                      _widgetAddButton(context),
                    ],
                  ),
                );
              },
              error: (err, s) {
                return Text(err.toString());
              },
              loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ));
        }),
      ),
    );
  }

  _widgetAddButton(context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StorePlaceScreen()),
          )
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(right: 6, bottom: 6),
          alignment: Alignment.center,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            size: 20,
          ),
        ),
      ),
    );
  }
}
