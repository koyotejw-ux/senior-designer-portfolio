import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Design System Documentation - Atomic Design Structure
class DesignSystemPage extends StatefulWidget {
  const DesignSystemPage({super.key});

  @override
  State<DesignSystemPage> createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends State<DesignSystemPage> {
  int _selectedTab = 0;

  final _tabs = ['Foundation', 'Design Tokens', 'Colors', 'Typography', 'Atoms', 'Molecules', 'Organisms'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1f3a),
        title: const Text(
          'Design System - Atomic Design',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: const Color(0xFF0A0E27),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final isSelected = _selectedTab == entry.key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = entry.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? Colors.cyan
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.cyan : Colors.white54,
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildFoundationTab(),
          _buildDesignTokensTab(),
          _buildColorsTab(),
          _buildTypographyTab(),
          _buildAtomsTab(),
          _buildMoleculesTab(),
          _buildOrganismsTab(),
        ],
      ),
    );
  }

  Widget _buildColorsTab() {
    final colors = [
      {'name': 'Primary Blue', 'color': AppColors.primaryBlue, 'usage': 'Main brand color, CTAs'},
      {'name': 'Accent Cyan', 'color': AppColors.accentCyan, 'usage': 'Highlights, interactive elements'},
      {'name': 'Highlight Green', 'color': AppColors.highlightGreen, 'usage': 'Success states, accents'},
      {'name': 'Gray 100', 'color': AppColors.gray100, 'usage': 'Text on dark backgrounds'},
      {'name': 'Gray 900', 'color': AppColors.gray900, 'usage': 'Dark mode backgrounds'},
      {'name': 'Light Gray 100', 'color': AppColors.lightGray100, 'usage': 'Light mode backgrounds'},
      {'name': 'Light Gray 900', 'color': AppColors.lightGray900, 'usage': 'Light mode backgrounds'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Color Palette'),
          const SizedBox(height: 16),
          const Text(
            '브랜드 색상 및 사용 가이드',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((colorData) {
              return Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1f3a),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: colorData['color'] as Color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      colorData['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      colorData['usage'] as String,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (colorData['color'] as Color).value.toRadixString(16).substring(2).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypographyTab() {
    final typography = [
      {'name': 'H1', 'style': AppTypography.h1, 'usage': 'Page titles'},
      {'name': 'H2', 'style': AppTypography.h2, 'usage': 'Section headers'},
      {'name': 'H3', 'style': AppTypography.h3, 'usage': 'Subsection titles'},
      {'name': 'H4', 'style': AppTypography.h4, 'usage': 'Card titles'},
      {'name': 'Body Large', 'style': AppTypography.bodyLarge, 'usage': 'Main content'},
      {'name': 'Body Medium', 'style': AppTypography.bodyMedium, 'usage': 'Secondary content'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Typography System'),
          const SizedBox(height: 16),
          const Text(
            '타이포그래피 스타일 가이드',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ...typography.map((typo) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          typo['name'] as String,
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        typo['usage'] as String,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The quick brown fox jumps',
                    style: (typo['style'] as TextStyle).copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Size: ${(typo['style'] as TextStyle).fontSize}px | Weight: ${(typo['style'] as TextStyle).fontWeight}',
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAtomsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Atoms - 기본 요소'),
          const SizedBox(height: 16),
          const Text(
            '가장 작은 단위의 UI 컴포넌트',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Buttons
          _buildComponentSection('Buttons', [
            _buildAtomExample(
              'Primary Button',
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Primary'),
              ),
              'lib/core/design_system/atoms/buttons/primary_button.dart',
            ),
            _buildAtomExample(
              'Secondary Button',
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.accentCyan),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Secondary', style: TextStyle(color: AppColors.accentCyan)),
              ),
              'lib/core/design_system/atoms/buttons/secondary_button.dart',
            ),
          ]),

          const SizedBox(height: 24),

          // Icons
          _buildComponentSection('Icons', [
            _buildAtomExample(
              'Navigation Icons',
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home, color: AppColors.accentCyan, size: 24),
                  const SizedBox(width: 16),
                  Icon(Icons.work, color: AppColors.accentCyan, size: 24),
                  const SizedBox(width: 16),
                  Icon(Icons.person, color: AppColors.accentCyan, size: 24),
                ],
              ),
              'Material Icons + Custom SVG',
            ),
          ]),

          const SizedBox(height: 24),

          // Text Inputs
          _buildComponentSection('Inputs', [
            _buildAtomExample(
              'Text Field',
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter text...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF1a1f3a),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.accentCyan),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              'lib/core/design_system/atoms/inputs/text_field.dart',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMoleculesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Molecules - 조합 요소'),
          const SizedBox(height: 16),
          const Text(
            'Atoms를 조합한 중간 단위 컴포넌트',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),

          _buildComponentSection('Cards', [
            _buildMoleculeExample(
              'Project Card',
              Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1a1f3a),
                      const Color(0xFF0A0E27),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.white38, size: 48),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Project Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Project description goes here...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              'lib/features/home/presentation/widgets/holographic_card.dart',
              'Atoms: Image + Text + Container',
            ),
          ]),

          const SizedBox(height: 24),

          _buildComponentSection('Form Groups', [
            _buildMoleculeExample(
              'Input with Label',
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'your@email.com',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: const Color(0xFF1a1f3a),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.accentCyan),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              'lib/core/design_system/molecules/form/labeled_input.dart',
              'Atoms: Label + TextField',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildOrganismsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Organisms - 복합 컴포넌트'),
          const SizedBox(height: 16),
          const Text(
            'Molecules를 조합한 완전한 기능 단위',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),

          _buildOrganismCard(
            'Hero Section',
            'lib/features/home/presentation/widgets/hero_section.dart',
            'Landing page hero with logo, title, and contact',
            ['Logo (Atom)', 'Heading Text (Atom)', 'Contact Info (Molecule)'],
          ),

          _buildOrganismCard(
            'Portfolio Gallery',
            'lib/features/home/presentation/widgets/portfolio_gallery_section.dart',
            'Grid of project cards with filtering',
            ['Project Card (Molecule) × N', 'Filter Buttons (Atoms)', 'Grid Layout'],
          ),

          _buildOrganismCard(
            'Experience Section',
            'lib/features/home/presentation/widgets/experience_section.dart',
            'Timeline of career history',
            ['Experience Card (Molecule) × N', 'Timeline (Atoms)', 'Section Header (Molecule)'],
          ),

          _buildOrganismCard(
            'Skills Section',
            'lib/features/home/presentation/widgets/skills_section.dart',
            'Categorized skill display',
            ['Skill Category Card (Molecule) × N', 'Skill Tag (Atom) × N'],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildComponentSection(String title, List<Widget> examples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.accentCyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...examples,
      ],
    );
  }

  Widget _buildAtomExample(String name, Widget preview, String path) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ATOM',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E27),
              borderRadius: BorderRadius.circular(8),
            ),
            child: preview,
          ),
          const SizedBox(height: 12),
          Text(
            path,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoleculeExample(String name, Widget preview, String path, String composition) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'MOLECULE',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            composition,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E27),
              borderRadius: BorderRadius.circular(8),
            ),
            child: preview,
          ),
          const SizedBox(height: 12),
          Text(
            path,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganismCard(String name, String path, String description, List<String> parts) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'ORGANISM',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            path,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Components:',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...parts.map((part) => Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: AppColors.accentCyan, size: 16),
                const SizedBox(width: 8),
                Text(
                  part,
                  style: TextStyle(
                    color: AppColors.accentCyan,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFoundationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('🏛️ Foundation - 디자인 시스템 기초'),
          const SizedBox(height: 24),

          // Design Principles
          _buildFoundationCard(
            '디자인 원칙 (Design Principles)',
            [
              '• 일관성 (Consistency): 모든 컴포넌트와 패턴이 일관된 규칙을 따릅니다',
              '• 접근성 (Accessibility): WCAG 2.1 AA 기준을 준수합니다',
              '• 확장성 (Scalability): 미래의 요구사항에 대비한 유연한 구조',
              '• 성능 (Performance): 최적화된 렌더링과 로딩 속도',
            ],
            Colors.cyan,
          ),

          const SizedBox(height: 16),

          // Grid System
          _buildFoundationCard(
            '그리드 시스템 (Grid System)',
            [
              '• 12-Column Grid: 반응형 레이아웃의 기본 그리드',
              '• Breakpoints:',
              '  - Mobile: < 768px',
              '  - Tablet: 768px - 1024px',
              '  - Desktop: > 1024px',
              '• Gutter: 16px (Mobile), 24px (Desktop)',
              '• Margin: 16px (Mobile), 48px (Desktop)',
            ],
            Colors.blue,
          ),

          const SizedBox(height: 16),

          // Spacing System
          _buildFoundationCard(
            '간격 시스템 (Spacing System)',
            [
              '• 4px Base Unit: 모든 간격은 4의 배수',
              '• Scale: 4, 8, 12, 16, 24, 32, 48, 64, 96',
              '• Vertical Rhythm: 일관된 수직 간격 유지',
              '• Component Padding: 내부 여백 표준화',
            ],
            Colors.purple,
          ),

          const SizedBox(height: 16),

          // Border Radius
          _buildFoundationCard(
            '모서리 반경 (Border Radius)',
            [
              '• Small: 4px - 작은 UI 요소 (버튼, 입력 필드)',
              '• Medium: 8px - 카드, 패널',
              '• Large: 12px - 모달, 큰 컨테이너',
              '• XLarge: 16px - 히어로 섹션, 특별한 강조',
              '• Round: 50% - 아바타, 뱃지',
            ],
            Colors.green,
          ),

          const SizedBox(height: 16),

          // Elevation & Shadows
          _buildFoundationCard(
            '고도 및 그림자 (Elevation & Shadows)',
            [
              '• Level 1: 0 2px 4px rgba(0,0,0,0.1) - 카드',
              '• Level 2: 0 4px 8px rgba(0,0,0,0.15) - 버튼 hover',
              '• Level 3: 0 8px 16px rgba(0,0,0,0.2) - 드롭다운',
              '• Level 4: 0 16px 24px rgba(0,0,0,0.25) - 모달',
              '• Level 5: 0 24px 32px rgba(0,0,0,0.3) - 다이얼로그',
            ],
            Colors.orange,
          ),

          const SizedBox(height: 16),

          // Animation
          _buildFoundationCard(
            '애니메이션 (Animation)',
            [
              '• Duration: 200ms (빠름), 300ms (보통), 500ms (느림)',
              '• Easing: ease-out (진입), ease-in (종료)',
              '• Transition: opacity, transform, color',
              '• Micro-interactions: 사용자 피드백 즉시 제공',
            ],
            Colors.pink,
          ),
        ],
      ),
    );
  }

  Widget _buildDesignTokensTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('🎨 Design Tokens - 디자인 토큰'),
          const SizedBox(height: 16),
          const Text(
            '디자인 토큰은 디자인 시스템의 핵심 값들을 정의합니다. 색상, 타이포그래피, 간격 등을 변수화하여 일관성과 유지보수성을 높입니다.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Color Tokens
          _buildTokenSection(
            'Color Tokens',
            [
              {'token': '--color-primary', 'value': '#0068B3', 'usage': 'Primary brand color'},
              {'token': '--color-accent', 'value': '#009DDC', 'usage': 'Accent/highlight color'},
              {'token': '--color-success', 'value': '#C1D72E', 'usage': 'Success states'},
              {'token': '--color-error', 'value': '#FF4757', 'usage': 'Error states'},
              {'token': '--color-warning', 'value': '#FFB800', 'usage': 'Warning states'},
              {'token': '--color-info', 'value': '#009DDC', 'usage': 'Info states'},
            ],
            Colors.cyan,
          ),

          const SizedBox(height: 24),

          // Typography Tokens
          _buildTokenSection(
            'Typography Tokens',
            [
              {'token': '--font-family-base', 'value': 'Inter', 'usage': 'Body text'},
              {'token': '--font-family-mono', 'value': 'Roboto Mono', 'usage': 'Code snippets'},
              {'token': '--font-size-h1', 'value': '48px', 'usage': 'Page titles'},
              {'token': '--font-size-h2', 'value': '40px', 'usage': 'Section headers'},
              {'token': '--font-size-body', 'value': '18px', 'usage': 'Body text'},
              {'token': '--font-weight-regular', 'value': '400', 'usage': 'Normal text'},
              {'token': '--font-weight-bold', 'value': '700', 'usage': 'Emphasized text'},
            ],
            Colors.purple,
          ),

          const SizedBox(height: 24),

          // Spacing Tokens
          _buildTokenSection(
            'Spacing Tokens',
            [
              {'token': '--space-xs', 'value': '4px', 'usage': 'Minimal spacing'},
              {'token': '--space-sm', 'value': '8px', 'usage': 'Small spacing'},
              {'token': '--space-md', 'value': '16px', 'usage': 'Medium spacing'},
              {'token': '--space-lg', 'value': '24px', 'usage': 'Large spacing'},
              {'token': '--space-xl', 'value': '32px', 'usage': 'Extra large spacing'},
              {'token': '--space-2xl', 'value': '48px', 'usage': 'Section spacing'},
              {'token': '--space-3xl', 'value': '64px', 'usage': 'Major sections'},
            ],
            Colors.green,
          ),

          const SizedBox(height: 24),

          // Border Radius Tokens
          _buildTokenSection(
            'Border Radius Tokens',
            [
              {'token': '--radius-sm', 'value': '4px', 'usage': 'Buttons, inputs'},
              {'token': '--radius-md', 'value': '8px', 'usage': 'Cards, panels'},
              {'token': '--radius-lg', 'value': '12px', 'usage': 'Modals'},
              {'token': '--radius-xl', 'value': '16px', 'usage': 'Hero sections'},
              {'token': '--radius-round', 'value': '50%', 'usage': 'Avatars, badges'},
            ],
            Colors.orange,
          ),

          const SizedBox(height: 24),

          // Shadow Tokens
          _buildTokenSection(
            'Shadow Tokens',
            [
              {'token': '--shadow-sm', 'value': '0 2px 4px rgba(0,0,0,0.1)', 'usage': 'Subtle elevation'},
              {'token': '--shadow-md', 'value': '0 4px 8px rgba(0,0,0,0.15)', 'usage': 'Cards, buttons'},
              {'token': '--shadow-lg', 'value': '0 8px 16px rgba(0,0,0,0.2)', 'usage': 'Dropdowns'},
              {'token': '--shadow-xl', 'value': '0 16px 24px rgba(0,0,0,0.25)', 'usage': 'Modals'},
            ],
            Colors.blue,
          ),

          const SizedBox(height: 24),

          // Usage in Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1f3a),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💻 Flutter에서 사용하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0E27),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SelectableText(
                    '''// 색상 사용
AppColors.primaryBlue
AppColors.accentCyan

// 타이포그래피 사용
AppTypography.h1
AppTypography.bodyLarge

// 간격 사용
const EdgeInsets.all(16)  // space-md
const SizedBox(height: 24)  // space-lg

// Border Radius 사용
BorderRadius.circular(8)  // radius-md

// 그림자 사용
BoxShadow(
  color: Colors.black.withOpacity(0.15),
  blurRadius: 8,
  offset: const Offset(0, 4),
)''',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 11,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoundationCard(String title, List<String> items, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTokenSection(String title, List<Map<String, String>> tokens, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: accentColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...tokens.map((token) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1f3a),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  token['token']!,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  token['value']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  token['usage']!,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
