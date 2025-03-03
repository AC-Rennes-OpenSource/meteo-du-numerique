import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'category.dart';
import 'service_quality.dart';

part 'digital_service.g.dart';

@JsonSerializable()
class DigitalService {
  final int? id;
  final String? name;
  final String? description;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Category? category;
  final ServiceQuality? qualityOfService;
  final bool isVisible;

  DigitalService({
    this.id,
    this.name,
    this.description,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.qualityOfService,
    this.isVisible = true,
  });

  factory DigitalService.fromJson(Map<String, dynamic> json) => _$DigitalServiceFromJson(json);
  
  // Custom factory for Strapi5 format
  factory DigitalService.fromStrapi5Json(Map<String, dynamic> json) {
    // Extract category data or create default
    final categoryData = json['mdn_categorie'] ?? {};
    final category = Category(
      id: (categoryData['id'] as num?)?.toInt(),
      name: categoryData['libelle'] as String?,
      color: categoryData['couleur'] as String?,
    );

    // Create a default service quality
    // In a real scenario, this would be determined based on current status
    final defaultQuality = ServiceQuality(id: 1, name: 'Fonctionnement habituel');

    // Extract description content
    String? descriptionText;
    String? regularDescription;
    String? newsDescription;
    
    // Process the regular description
    if (json['description'] != null) {
      try {
        // If description is a JSON string (Strapi rich text format), try to extract text
        final desc = json['description'] as String;
        if (desc.startsWith('[{') && desc.endsWith('}]')) {
          try {
            final parsedDesc = jsonDecode(desc) as List;
            final textParts = <String>[];
            
            for (var block in parsedDesc) {
              if (block is Map && block['type'] == 'paragraph' && block['children'] is List) {
                for (var child in block['children'] as List) {
                  if (child is Map && child['text'] is String) {
                    textParts.add(child['text'] as String);
                  }
                }
              }
            }
            
            if (textParts.isNotEmpty) {
              regularDescription = textParts.join('\n\n');
            } else {
              regularDescription = desc;
            }
          } catch (e) {
            // If parsing fails, use the original string
            regularDescription = desc;
          }
        } else {
          regularDescription = desc;
        }
      } catch (e) {
        regularDescription = json['description'] as String?;
      }
    }
    
    // Check if there's a news item (actualite)
    if (json['mdn_actualite'] != null && json['mdn_actualite']['description'] != null) {
      newsDescription = json['mdn_actualite']['description'] as String?;
      
      // Combine both descriptions with a separator
      if (regularDescription != null && regularDescription.isNotEmpty) {
        descriptionText = "ACTUALITÉ : $newsDescription\n\n---\n\n$regularDescription";
      } else {
        descriptionText = "ACTUALITÉ : $newsDescription";
      }
    } else {
      // No news, just use the regular description
      descriptionText = regularDescription;
    }

    return DigitalService(
      id: (json['id'] as num?)?.toInt(),
      name: json['libelle'] as String?,
      description: descriptionText,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      category: category,
      qualityOfService: defaultQuality,
    );
  }

  Map<String, dynamic> toJson() => _$DigitalServiceToJson(this);
}