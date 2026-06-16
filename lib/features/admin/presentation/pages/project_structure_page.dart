import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Project Structure Viewer - Shows file hierarchy and code documentation
class ProjectStructurePage extends StatefulWidget {
  const ProjectStructurePage({super.key});

  @override
  State<ProjectStructurePage> createState() => _ProjectStructurePageState();
}

class _ProjectStructurePageState extends State<ProjectStructurePage> {
  String? _selectedFile;

  final _projectStructure = const {
    'lib': {
      'core': {
        'constants': ['app_constants.dart - 앱 전역 상수'],
        'theme': [
          'app_colors.dart - 색상 팔레트',
          'app_typography.dart - 타이포그래피',
          'theme_provider.dart - 테마 관리'
        ],
        'router': ['app_router.dart - 라우팅 설정'],
      },
      'features': {
        'home': {
          'models': [
            'project_model.dart → Portfolio Gallery',
            'experience_model.dart → Experience Section',
            'profile_model.dart → About Section',
            'skill_model.dart → Skills Section',
          ],
          'providers': [
            'content_provider.dart - 서버 데이터 로딩',
            'resume_provider.dart - 이력서 데이터',
          ],
          'widgets': [
            'hero_section.dart - 메인 히어로 영역',
            'about_section.dart - 자기소개 섹션',
            'experience_section.dart - 경력 섹션',
            'portfolio_gallery_section.dart - 포트폴리오 갤러리',
            'skills_section.dart - 기술 스택 섹션',
            'resume_section.dart - 이력서 요약',
          ],
        },
        'admin': {
          'widgets': [
            'profile_editor.dart → Profile 수정 → About Section',
            'experience_editor.dart → Experience 수정 → Experience Section',
            'project_editor.dart → Project 수정 → Portfolio Gallery',
            'skill_editor.dart → Skill 수정 → Skills Section',
          ],
        },
      },
    },
  };

  final _dataFlow = [
    {
      'title': '데이터 흐름',
      'items': [
        '1. server/data/db.json - 모든 데이터 저장소',
        '2. content_provider.dart - 데이터 로드 및 캐싱',
        '3. 각 Section 위젯 - UI 렌더링',
      ],
    },
    {
      'title': '어드민 수정 → 프론트 반영',
      'items': [
        '1. Admin Editor에서 수정',
        '2. content_provider API 호출',
        '3. server/data/db.json 업데이트',
        '4. 프론트엔드 자동 리로드 (Riverpod)',
      ],
    },
  ];

  final _componentMapping = {
    'Profile Editor': {
      'affects': ['About Section', 'Resume Section'],
      'file': 'lib/features/admin/presentation/widgets/profile_editor.dart',
      'data': 'server/data/db.json - profile object',
    },
    'Experience Editor': {
      'affects': ['Experience Section', 'Resume Section'],
      'file': 'lib/features/admin/presentation/widgets/experience_editor.dart',
      'data': 'server/data/db.json - experience array',
    },
    'Project Editor': {
      'affects': ['Portfolio Gallery Section', 'Project Detail Page'],
      'file': 'lib/features/admin/presentation/widgets/project_editor.dart',
      'data': 'server/data/db.json - projects array',
    },
    'Skill Editor': {
      'affects': ['Skills Section'],
      'file': 'lib/features/admin/presentation/widgets/skill_editor.dart',
      'data': 'server/data/db.json - skills array',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1f3a),
        title: const Text(
          'Project Structure & Documentation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // Left Panel - Structure Tree
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1a1f3a),
                border: Border(
                  right: BorderSide(color: Colors.cyan.withOpacity(0.3)),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('📁 File Structure'),
                    const SizedBox(height: 16),
                    _buildTree(_projectStructure, 0),
                    const SizedBox(height: 32),
                    _buildSectionHeader('🔄 Data Flow'),
                    const SizedBox(height: 16),
                    ..._dataFlow.map((section) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section['title'] as String,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...(section['items'] as List<String>).map((item) =>
                          Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 4),
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),

          // Right Panel - Component Mapping
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF0A0E27),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('🎯 Component Impact Map'),
                    const SizedBox(height: 24),
                    Text(
                      '어드민에서 수정하면 어디가 바뀌나요?',
                      style: TextStyle(
                        color: Colors.cyan.shade300,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ..._componentMapping.entries.map((entry) =>
                      _buildComponentCard(
                        entry.key,
                        entry.value as Map<String, dynamic>,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.withOpacity(0.2), Colors.blue.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.cyan.withOpacity(0.5)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTree(Map<String, dynamic> tree, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tree.entries.map((entry) {
        final indent = level * 20.0;

        if (entry.value is Map) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: indent, bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder,
                      color: Colors.amber.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTree(entry.value as Map<String, dynamic>, level + 1),
            ],
          );
        } else if (entry.value is List) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: indent, bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_open,
                      color: Colors.orange.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ...(entry.value as List<String>).map((file) =>
                Padding(
                  padding: EdgeInsets.only(left: indent + 20, bottom: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: Colors.cyan.shade400,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          file,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildComponentCard(String title, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan.shade700, Colors.blue.shade700],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('📝 File', data['file'] as String),
          _buildInfoRow('💾 Data', data['data'] as String),
          const SizedBox(height: 8),
          const Text(
            '영향받는 화면:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ...(data['affects'] as List<String>).map((affect) =>
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward, color: Colors.greenAccent, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    affect,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
