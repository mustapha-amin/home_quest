import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/features/btm_nav_bar/agent/listings/controller/property_listing_ctrl.dart';

class Listings extends ConsumerWidget {
  const Listings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(fetchListingsByAgentIDProvider(
              ref.watch(firebaseAuthProvider).currentUser!.uid))
          .when(
            data: (listings) {
              return ListView.builder(
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(listings[index].propertyType.name),
                      subtitle: Text(listings[index].listingType.name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          ref.read(deleteListingProvider(listings[index].id));
                        },
                      ),
                      leading: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(listings[index].imagesUrls[0]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ).padX(5).padY(4);
                },
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error: $error $stackTrace'),
              );
            },
          ),
    );
  }
}
