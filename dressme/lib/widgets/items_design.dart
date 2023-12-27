import 'package:dressme/models/items.dart';
import 'package:flutter/material.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.pinkAccent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 340,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Color(0xFFF882A6),
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 230.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
