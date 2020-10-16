// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api.g.dart';

const String CHART_TYPE_BAR = "BAR";
const String CHART_TYPE_LINE = "LINE";
const String CHART_TYPE_SCATTER = "SCATTER";
const String CHART_TYPE_SCATTER_LINE = "SCATTER_LINE";

/// Manipulates app data,
abstract class DashboardApi {
  CategoryApi get categories;
  EntryApi get entries;
}

/// Manipulates [Category] data.
abstract class CategoryApi {
  Future<Category> delete(String id);

  Future<Category> get(String id);

  Future<Category> insert(Category category);

  Future<List<Category>> list();

  Future<Category> update(Category category, String id);

  Stream<List<Category>> subscribe();
}

/// Manipulates [Entry] data.
abstract class EntryApi {
  Future<Entry> delete(String categoryId, String id);

  Future<Entry> get(String categoryId, String id);

  Future<Entry> insert(String categoryId, Entry entry);

  Future<List<Entry>> list(String categoryId);

  Future<Entry> update(String categoryId, String id, Entry entry);

  Stream<List<Entry>> subscribe(String categoryId);
}

/// Something that's being tracked, e.g. Hours Slept, Cups of water, etc.
@JsonSerializable()
class Category {
  String name;
  String type;

  @JsonKey(ignore: true)
  String id;

  Category(this.name, this.type);

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  operator ==(Object other) => other is Category && other.id == id;
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return '<Category id=$id>';
  }
}

/// Something that's shown above everything, e.g. Total connections, etc.
@JsonSerializable()
class Highlight {
  String name;
  String value;
  IconData icon;

  @JsonKey(ignore: true)
  String id;

  Highlight(this.name, this.value, this.icon);

  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json);

  Map<String, dynamic> toJson() => _$HighlightToJson(this);

  @override
  operator ==(Object other) => other is Highlight && other.id == id;
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return '<Highlight id=$id>';
  }
}

/// A number tracked at a point in time.
@JsonSerializable()
class Entry {
  int value;
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  DateTime time;

  @JsonKey(ignore: true)
  String id;

  Entry(this.value, this.time);

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  Map<String, dynamic> toJson() => _$EntryToJson(this);

  static DateTime _timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch);
  }

  static Timestamp _dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
  }

  @override
  operator ==(Object other) => other is Entry && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '<Entry id=$id>';
  }
}
