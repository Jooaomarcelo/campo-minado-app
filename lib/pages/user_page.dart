import 'package:campo_minado_app/core/models/user_data.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as UserData;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverPersistantDelegate(user),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 2000),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SliverPersistantDelegate extends SliverPersistentHeaderDelegate {
  final UserData user;

  double maxHeaderHeight = 200;
  double minHeaderHeight = kToolbarHeight + 55;

  double maxImageSize = 136;
  double minImageSize = 40;

  SliverPersistantDelegate(this.user);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final mediaSize = MediaQuery.of(context).size;

    final percent = shrinkOffset / (maxHeaderHeight - 65);
    final percent2 = shrinkOffset / maxHeaderHeight;

    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition = ((mediaSize.width / 2 - 65) * (1 - percent))
        .clamp(minImageSize, maxImageSize);

    return Container(
      color: Color.fromRGBO(18, 18, 18, 1),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white
                  .withValues(alpha: percent2 * 2 < 1 ? percent2 * 2 : 1),
              width: 0.5,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 15,
              left: currentImagePosition + 50,
              child: Text(
                user.name,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: percent2),
                  fontSize: 20,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 5,
              left: 0,
              child: BackButton(),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 5,
              left: currentImagePosition,
              bottom: 0,
              child: Container(
                width: currentImageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.imageUrl),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
