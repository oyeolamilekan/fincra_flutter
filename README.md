# Flutter Basqet

This package makes it easy to use the fincra in your flutter project.

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/oyeolamilekan/fincra_flutter/blob/master/001_screen_shot.png?raw=true" width="200">
<img src="https://github.com/oyeolamilekan/fincra_flutter/blob/master/002_screen_shot.png?raw=true" width="200">
</p>

### How to Use plugin

```dart
import 'package:fincra_flutter/fincra_flutter.dart';

FincraFlutter.launchFincra(
    context,
    publicKey:"<public_test_key|public_prod_key>",
    amount: "4000",
    name: "oyee",
    phoneNumber: "+2348087307896",
    currency: "NGN",
    email: "oye@qww.com",
    feeBearer: "business",
    onSuccess: (data) {},
    onError: (data) {},    
    onClose: () {},
)

```
