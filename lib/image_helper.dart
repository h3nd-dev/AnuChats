import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

ImageProvider loadImage(String imageUrl) {
  // Check if the URL is a base64 encoded image
  if (imageUrl.startsWith('data:image')) {
    // Extract base64 data
    final base64Data = imageUrl.split(',').last;
    return MemoryImage(base64Decode(base64Data));
  }

  // Check if the URL is a local file path
  if (imageUrl.startsWith('/')) {
    final file = File(imageUrl);
    if (file.existsSync()) {
      return FileImage(file);
    }
  }

  // Default to treating the URL as a network image
  return NetworkImage(imageUrl);
}
