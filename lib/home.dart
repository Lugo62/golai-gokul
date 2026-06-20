import 'package:chatbot/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController tc = TextEditingController();
  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  Future<void> sendmessage() async {
    await HapticFeedback.lightImpact();
    final text = tc.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": text});
      _isTyping = true;
    });
    tc.clear();
    _scrollToBottom();

    try {
      apiintegration api = apiintegration();
      final reply = await api.apiConnection(messages);
      setState(() {
        messages.add({"role": "assistant", "content": reply});
        _isTyping = false;
      });
    } catch (_) {
      setState(() {
        _isTyping = false;
      });
    }
    _scrollToBottom();
  }

  @override
  void dispose() {
    tc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
      p: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        height: 1.6,
        color: const Color(0xFFE2E2E9),
      ),
      strong: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      h1: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      h2: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      h3: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),

      tableBody: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        color: const Color(0xFFE2E2E9),
      ),
      tableHead: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      tableBorder: TableBorder.all(
        color: Colors.white.withOpacity(0.15),
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.all(12),
      tableCellsDecoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withOpacity(0.3),
      ),

      listBullet: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        color: const Color(0xFF9D4EDD),
      ),

      
      code: GoogleFonts.firaCode(
        fontSize: 14,
        color: const Color(0xFF06D6A0),
        backgroundColor: const Color(0xFF0F0F14),
      ),
      codeblockPadding: const EdgeInsets.all(14),
      codeblockDecoration: BoxDecoration(
        color: const Color(0xFF0F0F14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222235)),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161F),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF222235),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF9D4EDD),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GOLAI",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _isTyping ? "Typing.." : "Online",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _isTyping
                        ? const Color(0xFF9D4EDD)
                        : const Color(0xFF06D6A0),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Card(
              elevation: 13,
              color: const Color(0xFF222235),
              child: SizedBox(
                width: 37,
                height: 37,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  color: const Color(0xFF9D4EDD),
                  iconSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "How can I help you today?",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final isUser = messages[index]["role"] == "user";
                      final rawContent = messages[index]["content"].toString();

                      return Container(
                        width: double.infinity,
                        color: isUser
                            ? Colors.transparent
                            : const Color(0xFF16161F),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isUser
                                      ? Icons.person_outline
                                      : Icons.smart_toy_outlined,
                                  size: 16,
                                  color: isUser
                                      ? const Color(0xFF9D4EDD)
                                      : const Color(0xFF06D6A0),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isUser ? "You" : "GOLAI",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SelectionArea(
                              child: MarkdownBody(
                                data: rawContent,
                                styleSheet: markdownStyleSheet,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF9D4EDD).withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 24,
              top: 12,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF16161F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF222235),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: tc,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message...",
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: sendmessage,
                  child: Card(
                    elevation: 20,
                    shape: const CircleBorder(),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6200EE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
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
}
