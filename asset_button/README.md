# image_button

image button utilities.

Image button needs two asset image: one is normal(neccesary) , one is hover(not neccesary).

Normal image is for normal displaying, hover image is shown when mouse hover the button area.

When taping the button,  shrink animation plays.

------
e.g. demo app

<!-- ![demo app](https://i.ibb.co/X4CPfcp/demo-app.png) -->
<img src="https://i.ibb.co/X4CPfcp/demo-app.png" width="30%" height="30%">



------
use independent image

```
WidgetImageButton(
  imageNormal:
      WidgetAssetImage(assetPath: 'assets/images/icon_normal.png'),
  imageHover:
      WidgetAssetImage(assetPath: 'assets/images/icon_hover.png'),
  onTap: () {
    print('independent icon image button');
  },
),
```
------
crop image from one whole image

```
WidgetImageButton(
  imageNormal: WidgetAssetImage(
      assetPath: 'assets/images/icons.png',
      cropRect: Rect.fromLTWH(58, 165, 95, 95)),
  imageHover: WidgetAssetImage(
      assetPath: 'assets/images/icons.png',
      cropRect: Rect.fromLTWH(170, 164, 95, 95)),
  onTap: () {
    print('image button icon crop from one image');
  },
)
```

--------

resource:


| resource | image |
| ------   | ------ |
| icon hover | ![icon hover](https://i.ibb.co/9qjtV4f/icon-hover.png) |
| icon normal | ![icon normal](https://i.ibb.co/2S1hRHC/icon-normal.png) |
| one whole image | ![one whole image](https://i.ibb.co/9hLvLsg/icons.png) |
| background | ![background](https://i.ibb.co/W6sw2t1/bkg-code.png) |

