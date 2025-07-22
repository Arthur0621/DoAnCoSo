import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:moneynest/features/category/data/model/category_model.dart';
import 'package:moneynest/features/wallet/data/model/wallet_model.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_category_selector.dart';
import 'package:moneynest/features/transaction/presentation/components/form/transaction_form_wallet_selector.dart';
import 'package:moneynest/features/budget/riverpod/budget_providers.dart';
import 'package:moneynest/core/database/moneynest_database.dart';

class BudgetFormScreen extends ConsumerWidget {
  const BudgetFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm ngân sách mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _BudgetFormContent(
          nameController: nameController,
          categoryController: categoryController,
          amountController: amountController,
          ref: ref,
        ),
      ),
    );
  }
}

class _BudgetFormContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController amountController;
  final WidgetRef ref;

  const _BudgetFormContent({
    Key? key,
    required this.nameController,
    required this.categoryController,
    required this.amountController,
    required this.ref,
  }) : super(key: key);

  @override
  State<_BudgetFormContent> createState() => _BudgetFormContentState();
}

class _BudgetFormContentState extends State<_BudgetFormContent> {
  bool isRecurring = false;
  DateTime? startDate;
  DateTime? endDate;
  CategoryModel? selectedCategory;
  WalletModel? selectedWallet;
  final notesController = TextEditingController();
  bool isSaving = false;
  String? errorText;

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = startDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? now,
      firstDate: startDate ?? now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> _saveBudget() async {
    setState(() {
      errorText = null;
      isSaving = true;
    });

    final name = widget.nameController.text.trim();
    final amountText = widget.amountController.text.trim();
    final amount = double.tryParse(amountText);

    // Thêm log debug
    print('[DEBUG] name: $name');
    print('[DEBUG] selectedCategory: $selectedCategory');
    print('[DEBUG] selectedWallet: $selectedWallet');
    print('[DEBUG] amount: $amount');
    print('[DEBUG] startDate: $startDate');
    print('[DEBUG] endDate: $endDate');
    print('[DEBUG] isRecurring: $isRecurring');

    if (name.isEmpty || selectedCategory == null || selectedWallet == null || amount == null || amount <= 0 || startDate == null || (!isRecurring && endDate == null)) {
      setState(() {
        errorText = 'Vui lòng điền đầy đủ thông tin hợp lệ';
        isSaving = false;
      });
      return;
    }

    final dao = widget.ref.read(budgetDaoProvider);
    try {
      await dao.insertBudget(
        BudgetsCompanion(
          walletId: drift.Value(selectedWallet!.id!),
          categoryId: drift.Value(selectedCategory!.id!),
          amount: drift.Value(amount),
          startDate: drift.Value(startDate!),
          endDate: isRecurring ? const drift.Value.absent() : drift.Value(endDate!),
          isRecurring: drift.Value(isRecurring),
          name: drift.Value(name),
          usedAmount: drift.Value(0.0), // Đảm bảo không null khi tạo mới
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorText = 'Lưu ngân sách thất bại: $e';
      });
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.nameController,
            decoration: const InputDecoration(
              labelText: 'Tên ngân sách',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          // Category dropdown selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple, width: 1.2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.purple.shade50,
            ),
            child: TransactionCategorySelector(
              controller: TextEditingController(text: selectedCategory?.title ?? ''),
              onCategorySelected: (cat) {
                setState(() {
                  selectedCategory = cat;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          // Wallet dropdown selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurple, width: 1.2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.purple.shade50,
            ),
            child: TransactionFormWalletSelector(
              selectedWallet: selectedWallet,
              onWalletSelected: (wallet) {
                setState(() {
                  selectedWallet = wallet;
                });
              },
              label: 'Chọn ví',
              hint: 'Chọn ví sử dụng',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: widget.amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Số tiền cần dùng',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          // Start date picker
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _pickStartDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ngày bắt đầu',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(startDate == null
                        ? 'Chọn ngày bắt đầu'
                        : '${startDate!.day}/${startDate!.month}/${startDate!.year}'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (!isRecurring)
                Expanded(
                  child: InkWell(
                    onTap: _pickEndDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Ngày kết thúc',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(endDate == null
                          ? 'Chọn ngày kết thúc'
                          : '${endDate!.day}/${endDate!.month}/${endDate!.year}'),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: isRecurring,
                onChanged: (value) {
                  setState(() {
                    isRecurring = value ?? false;
                    if (isRecurring) endDate = null;
                  });
                },
              ),
              const Text('Lặp lại hàng tháng'),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Ghi chú (tuỳ chọn)',
              border: OutlineInputBorder(),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(errorText!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSaving ? null : _saveBudget,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }
}