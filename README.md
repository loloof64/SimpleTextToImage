# Simple text to image

A simple text to image application.

## For developers

Project was built with Flutter 3.19.2

### Set up credentials

1. Log in to Hugging face
2. Go to https://huggingface.co/runwayml/stable-diffusion-v1-5
3. Click on 'Deploy' button, and select 'Inference API'
4. Select 'create a new token' if you don't have yet any token. (Otherwise just pick the displayed token) 
5. Save it in the file lib/credentials.dart

```dart
String token = "<YOUR_API_TOKEN>";
```