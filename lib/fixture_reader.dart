import 'dart:io';

String fixture(String name) => File("test/$name").readAsStringSync();