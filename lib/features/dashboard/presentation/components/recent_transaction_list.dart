part of '../screens/dashboard_screen.dart';


class RecentTransactionList extends ConsumerWidget {
  // Changed to ConsumerWidget
  const RecentTransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef
    final asyncTransactions = ref.watch(transactionsProvider);

    return asyncTransactions.when(
      data: (allTransactions) {
        if (allTransactions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.spacing20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Giao dịch gần đây',
                  style: AppTextStyles.heading6,
                ),
                const Gap(AppSpacing.spacing16),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spacing20,
                    ),
                    child: Text(
                      'No transactions yet.',
                      style: AppTextStyles.body3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        // Hiển thị tất cả giao dịch mới nhất, bao gồm cả chuyển tiền (transfer)
        final List<TransactionModel> recentTransactions = List.from(
          allTransactions,
        )..sort((a, b) => b.date.compareTo(a.date)); // Most recent first
        // Nếu muốn filter theo loại, có thể sửa ở đây, nhưng hiện tại sẽ giữ nguyên để bao gồm cả transfer
        final List<TransactionModel> displayTransactions = recentTransactions
            .take(5)
            .toList();

        return Container(
          padding: const EdgeInsets.all(AppSpacing.spacing20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Giao dịch gần đây ', style: AppTextStyles.heading6),
              const Gap(AppSpacing.spacing16),
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.spacing20,
                ), // Adjusted bottom padding
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = displayTransactions[index];
                  return TransactionTile(transaction: transaction);
                },
                separatorBuilder: (context, index) =>
                    const Gap(AppSpacing.spacing16),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
