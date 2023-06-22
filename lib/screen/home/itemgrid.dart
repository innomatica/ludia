import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../logic/ludia.dart';
import '../../model/ludia_item.dart';

class ItemGridView extends StatefulWidget {
  const ItemGridView({super.key});

  @override
  State<ItemGridView> createState() => _ItemGridViewState();
}

class _ItemGridViewState extends State<ItemGridView> {
  final _picker = ImagePicker();

  //
  // Setting Button
  //
  Widget _buildSettingsButton(LudiaLogic logic, LudiaItem item) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'gallery':
            final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
            debugPrint('picked.path:${image?.path}');
            if (image?.path != null) {
              item.imagePath = image!.path;
              logic.updateItem(item);
            }
            break;
          case 'camera':
            final XFile? image =
                await _picker.pickImage(source: ImageSource.camera);
            debugPrint('picked.path:${image?.path}');
            if (image?.path != null) {
              item.imagePath = image!.path;
              logic.updateItem(item);
            }
            break;
          case 'delete':
            logic.deleteItem(item);
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) {
        return <PopupMenuItem<String>>[
          const PopupMenuItem<String>(value: 'gallery', child: Text('Gallery')),
          const PopupMenuItem<String>(value: 'camera', child: Text('Camera')),
          const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
        ];
      },
      icon: Icon(
        Icons.settings_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  //
  // Item Card
  //
  Widget _buildItemCard(LudiaLogic logic, LudiaItem item) {
    final textStyle1 = Theme.of(context).textTheme.bodyLarge;
    final textStyle2 = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Theme.of(context).colorScheme.tertiary);

    return InkWell(
      onTap: item.imagePath != null
          ? () => showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    // title: const Text('Select Target'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () async {
                          await logic.setWallpaper(item, LudiaTarget.home);
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Set ', style: textStyle1),
                            Text('Home', style: textStyle2),
                            Text(' Screen', style: textStyle1),
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () async {
                          await logic.setWallpaper(item, LudiaTarget.lock);
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Set ', style: textStyle1),
                            Text('Lock', style: textStyle2),
                            Text(' Screen', style: textStyle1),
                          ],
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () async {
                          await logic.setWallpaper(item, LudiaTarget.both);
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Set ', style: textStyle1),
                            Text('Both', style: textStyle2),
                            Text(' Screen', style: textStyle1),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
          : null,
      child: Card(
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            item.imagePath != null
                ? Image.file(
                    File(item.imagePath!),
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.maxFinite,
                    // height: 48,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Center(
                        child: Text(
                      'Pick Image',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    )),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildSettingsButton(logic, item),
              ],
            )
          ],
        ),
      ),
    );
  }

  //
  // Body
  //
  Widget _buildBody(LudiaLogic logic, List<LudiaItem> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: logic.gridColumns),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildItemCard(logic, items[index]),
      ),
    );
  }

  //
  // Instruction
  //
  Widget _buildInstruction() {
    const style = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Click the button ', style: style),
              Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              const Text(' and ', style: style),
            ],
          ),
          const Text('create a new entry', style: style)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<LudiaLogic>();
    final items = logic.items;
    // debugPrint('items: $items');
    return items.isEmpty ? _buildInstruction() : _buildBody(logic, items);
  }
}
