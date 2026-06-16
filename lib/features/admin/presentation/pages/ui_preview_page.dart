import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/atoms/buttons/primary_button.dart';
import '../../../../core/design_system/atoms/buttons/secondary_button.dart';
import '../../../../core/design_system/atoms/inputs/text_input.dart' as design_system;
import '../../../../core/design_system/molecules/cards/info_card.dart';
import '../../../../core/theme/app_colors.dart';

/// UI Preview System - Live component rendering and testing
class UIPreviewPage extends StatefulWidget {
  const UIPreviewPage({super.key});

  @override
  State<UIPreviewPage> createState() => _UIPreviewPageState();
}

class _UIPreviewPageState extends State<UIPreviewPage> {
  String _selectedCategory = 'Atoms';
  String _selectedComponent = 'PrimaryButton';
  final Map<String, dynamic> _componentProps = {};

  final _categories = {
    'Atoms': ['PrimaryButton', 'SecondaryButton', 'TextInput'],
    'Molecules': ['InfoCard'],
    'Organisms': ['HeroSection', 'PortfolioGallery'],
  };

  final _componentSpecs = {
    'PrimaryButton': {
      'props': {
        'text': {'type': 'String', 'default': 'Click Me'},
        'isLoading': {'type': 'bool', 'default': false},
        'icon': {'type': 'IconData?', 'default': null},
      },
      'code': '''PrimaryButton(
  text: 'Click Me',
  onPressed: () {},
  icon: Icons.check,
)''',
    },
    'SecondaryButton': {
      'props': {
        'text': {'type': 'String', 'default': 'Cancel'},
        'isLoading': {'type': 'bool', 'default': false},
      },
      'code': '''SecondaryButton(
  text: 'Cancel',
  onPressed: () {},
)''',
    },
    'TextInput': {
      'props': {
        'label': {'type': 'String?', 'default': 'Email'},
        'hint': {'type': 'String?', 'default': 'Enter your email'},
      },
      'code': '''TextInput(
  label: 'Email',
  hint: 'Enter your email',
  onChanged: (value) {},
)''',
    },
    'InfoCard': {
      'props': {
        'title': {'type': 'String', 'default': 'Card Title'},
      },
      'code': '''InfoCard(
  title: 'Card Title',
  child: Text('Content goes here'),
)''',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeProps();
  }

  void _initializeProps() {
    final spec = _componentSpecs[_selectedComponent];
    if (spec != null) {
      final props = spec['props'] as Map<String, dynamic>;
      _componentProps.clear();
      props.forEach((key, value) {
        _componentProps[key] = value['default'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1f3a),
        title: const Text(
          'UI Component Preview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // Left Panel - Component Selection
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF1a1f3a),
              border: Border(
                right: BorderSide(color: Colors.cyan.withOpacity(0.3)),
              ),
            ),
            child: Column(
              children: [
                _buildCategorySelector(),
                Expanded(child: _buildComponentList()),
              ],
            ),
          ),

          // Center Panel - Live Preview
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF0A0E27),
              child: Column(
                children: [
                  _buildPreviewHeader(),
                  Expanded(child: _buildPreview()),
                ],
              ),
            ),
          ),

          // Right Panel - Props Editor & Code
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: const Color(0xFF1a1f3a),
              border: Border(
                left: BorderSide(color: Colors.cyan.withOpacity(0.3)),
              ),
            ),
            child: Column(
              children: [
                Expanded(flex: 2, child: _buildPropsEditor()),
                Expanded(flex: 3, child: _buildCodeViewer()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.cyan.withOpacity(0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._categories.keys.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  _selectedComponent = _categories[category]!.first;
                  _initializeProps();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentCyan.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentCyan
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? AppColors.accentCyan : Colors.white70,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildComponentList() {
    final components = _categories[_selectedCategory] ?? [];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: components.map((component) {
        final isSelected = _selectedComponent == component;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedComponent = component;
              _initializeProps();
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue.withOpacity(0.2)
                  : const Color(0xFF0A0E27),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : Colors.white10,
              ),
            ),
            child: Text(
              component,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreviewHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1f3a),
        border: Border(
          bottom: BorderSide(color: Colors.cyan.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility, color: Colors.cyan, size: 20),
          const SizedBox(width: 12),
          Text(
            'Live Preview - $_selectedComponent',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(40),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1f3a).withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.cyan.withOpacity(0.2)),
        ),
        child: _renderComponent(),
      ),
    );
  }

  Widget _renderComponent() {
    switch (_selectedComponent) {
      case 'PrimaryButton':
        return PrimaryButton(
          text: _componentProps['text'] ?? 'Click Me',
          isLoading: _componentProps['isLoading'] ?? false,
          icon: _componentProps['icon'],
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Button clicked!')),
            );
          },
        );

      case 'SecondaryButton':
        return SecondaryButton(
          text: _componentProps['text'] ?? 'Cancel',
          isLoading: _componentProps['isLoading'] ?? false,
          onPressed: () {},
        );

      case 'TextInput':
        return SizedBox(
          width: 300,
          child: design_system.TextInput(
            label: _componentProps['label'],
            hint: _componentProps['hint'],
          ),
        );

      case 'InfoCard':
        return SizedBox(
          width: 400,
          child: InfoCard(
            title: _componentProps['title'] ?? 'Card Title',
            child: const Text(
              'This is the card content. You can put any widget here.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        );

      default:
        return const Text(
          'Component preview not available',
          style: TextStyle(color: Colors.white54),
        );
    }
  }

  Widget _buildPropsEditor() {
    final spec = _componentSpecs[_selectedComponent];
    if (spec == null) return const SizedBox.shrink();

    final props = spec['props'] as Map<String, dynamic>;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.cyan.withOpacity(0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: Colors.cyan, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Properties',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: props.entries.map((entry) {
                return _buildPropEditor(
                  entry.key,
                  entry.value['type'],
                  _componentProps[entry.key],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropEditor(String propName, String type, dynamic value) {
    if (type == 'bool') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              propName,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Switch(
              value: value ?? false,
              onChanged: (newValue) {
                setState(() {
                  _componentProps[propName] = newValue;
                });
              },
              activeColor: AppColors.accentCyan,
            ),
          ],
        ),
      );
    } else if (type == 'String' || type == 'String?') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              propName,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: value?.toString() ?? ''),
              onChanged: (newValue) {
                setState(() {
                  _componentProps[propName] = newValue;
                });
              },
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF0A0E27),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildCodeViewer() {
    final spec = _componentSpecs[_selectedComponent];
    final code = spec?['code'] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.code, color: Colors.cyan, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                color: Colors.white54,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code as String));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E27),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white10),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  code as String,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
