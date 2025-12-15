import 'package:shared/shared.dart';

final progressKey = 'progress_input';

class ChallengeDetailBDUIGenerator {
  BDUIScreenModel generate(Challenge challenge) {
    return BDUIScreenModel(
      screenType: BDUIScreenType.challengeDetail,
      title: challenge.title,
      layout: BDUIElementModel(
        type: BDUIType.column,
        children: [
          _buildHeader(challenge),
          _buildDescription(challenge),
          _buildProgressSection(challenge),
          _buildAction(challenge),
        ],
      ),
    );
  }

  BDUIElementModel _buildHeader(Challenge challenge) {
    return BDUIElementModel(
      type: BDUIType.column,
      children: [
        BDUIElementModel(
          type: BDUIType.text,
          value: challenge.category,
          style: BDUITextStyleModel(
            fontSize: 16,
            color: '#666666',
          ),
        ),
        BDUIElementModel(
          type: BDUIType.text,
          value: challenge.title,
          style: BDUITextStyleModel(
            fontSize: 28,
            fontWeight: BDUIFontWeight.bold,
          ),
        ),
      ],
    );
  }

  BDUIElementModel _buildDescription(Challenge challenge) {
    return BDUIElementModel(
      type: BDUIType.container,
      decoration: BDUIDecorationModel(
        padding: BDUIPadding(top: 16, bottom: 16),
      ),
      child: BDUIElementModel(
        type: BDUIType.text,
        value: challenge.description,
        style: BDUITextStyleModel(
          fontSize: 16,
          color: '#424242',
        ),
      ),
    );
  }

  BDUIElementModel _buildProgressSection(Challenge challenge) {
    return BDUIElementModel(
      type: BDUIType.column,
      children: [
        BDUIElementModel(
          type: BDUIType.text,
          value: '📊 Ваш прогресс',
          style: BDUITextStyleModel(
            fontSize: 20,
            fontWeight: BDUIFontWeight.bold,
            color: '#1976D2',
          ),
        ),
        BDUIElementModel(
          type: BDUIType.progressBar,
          value: '${challenge.progressCurrent}/${challenge.progressTotal}',
          // Добавьте нужные поля для progress bar в вашу модель
        ),
        BDUIElementModel(
          type: BDUIType.text,
          value:
              '${challenge.progressCurrent}/${challenge.progressTotal} (${(challenge.progressPercentage * 100).toStringAsFixed(1)}%)',
          style: BDUITextStyleModel(
            fontSize: 16,
            fontWeight: BDUIFontWeight.bold,
          ),
        ),
      ],
    );
  }

  BDUIElementModel _buildAction(Challenge challenge) {
    return BDUIElementModel(
      type: BDUIType.container,
      decoration: BDUIDecorationModel(
        padding: BDUIPadding(top: 20),
      ),
      child: BDUIElementModel(
        type: BDUIType.button,
        value: '✅ Отметить прогресс',
        style: BDUITextStyleModel(
          color: '#FFFFFF',
        ),
        decoration: BDUIDecorationModel(
          color: '#2196F3',
          padding: BDUIPadding(top: 16, bottom: 16),
        ),
        actions: [
          BDUIActionModel(
            type: BDUIType.button,
            text: '✅ Отметить прогресс',
            action: BDUIActionData(
                type: BDUIActionType.showBottomSheet,
                challengeId: challenge.id,
                sheet: _buildProgressBottomSheet(challenge)),
          ),
        ],
      ),
    );
  }

  BDUIElementModel _buildProgressBottomSheet(Challenge challenge) {
    return BDUIElementModel(
      type: BDUIType.column,
      children: [
        BDUIElementModel(
          type: BDUIType.text,
          value: 'Введите ваш прогресс:',
          style: BDUITextStyleModel(
            fontSize: 16,
            fontWeight: BDUIFontWeight.bold,
          ),
        ),
        BDUIElementModel(
          type: BDUIType.container,
          decoration: BDUIDecorationModel(
            padding: BDUIPadding(top: 20, bottom: 20),
          ),
          child: BDUIElementModel(
            key: progressKey,
            type: BDUIType.textField,
            value: challenge.progressCurrent.toString(),
            // Добавьте нужные поля для text field
          ),
        ),
        BDUIElementModel(
          type: BDUIType.button,
          value: '💾 Сохранить',
          style: BDUITextStyleModel(
            color: '#FFFFFF',
          ),
          decoration: BDUIDecorationModel(
            color: '#4CAF50',
            padding: BDUIPadding(top: 16, bottom: 16),
          ),
          actions: [
            BDUIActionModel(
              type: BDUIType.button,
              text: '💾 Сохранить',
              action: BDUIActionData(
                type: BDUIActionType.trackProgress,
                challengeId: challenge.id,
                progressKey: progressKey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
