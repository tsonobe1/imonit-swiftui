# imonit

## イメージ
<img width="1425" alt="image" src="https://github.com/tsonobe1/SwiftUIPlayGround/assets/40202387/9c53f031-ad4d-4c59-b5be-7440013ef948">



## 概要
SwiftUIでカレンダーアプリを作成中

---
### インタビュー：自分への質問から得られたこと

- **現在のスケジュール管理の方法**
  - カレンダーアプリでスケジュールを管理し、アラーム通知も活用している。

- **困難点および不満点**
  - 現在のカレンダーアプリでは、目標とそれに関連するタスクの関連性が不明確である。
  - 目標を細分化して日々のタスクに反映する際、関連性が失われてしまう。
  - 長期的な目標の管理が困難

- **必要な機能および要件**
  - 大きな目標を細分化できる機能が必要で、それらの関連性を視覚的に把握できる機能。
  - 長期的なスケジュールを俯瞰的に表示し、目標達成までの日数や時間の経過を把握できること
  - 目標のためのタスクをスケジュールできること


### Pain Points

1. 目標とタスクの関連性が不明確であり、効果的な目標達成が困難である。
2. 長期的な目標の管理と日々のタスク管理が分断されており、総合的なスケジュールの俯瞰が難しい。
3. カレンダーアプリでは目標やタスクの細分化ができず、目標達成までの道のりが見えにくい。
4. タスクの優先順位設定と進捗管理が煩雑であり、効率的なタスク管理が困難である。
5. 重要なタスクや予定を見逃してしまうリスクがあり、通知機能が不十分である。
6. スケジュールの柔軟性に欠けており、予定の変更や調整が難しい。
7. 目標達成までの時間や進捗がわかりにくく、モチベーションの維持が困難である。

### ユーザーストーリー

1. 長期目標とそれに関連するタスクやTODOの関連性を明確に把握したい。これによって集中力とモチベーションを維持できる。
2. 短期および長期の目標を含む包括的なスケジュールビューを持ちたい。これによってタスクを効果的に計画し、優先順位を付けられる。
3. 長期目標をより小さなマイルストーンやタスクに分割し、日々のスケジュールに反映できるようにしたい。これによって進捗を追跡し、目標達成に向けた適切な進行ができる。
4. 目標やタスクに関連する通知やリマインダーを受け取りたい。これによって組織的に作業ができ、締切を守れる。
5. 目標とタスクの異なるレベルを容易にナビゲートできる、ユーザーフレンドリーなインターフェイスを望む。全体的な進捗とタイムラインが視覚的に表示されることで、スケジュールを明確に把握し、モチベーションを維持できる。


### ユーザージャーニーマップ：スケジュール管理アプリの使用体験

このマップは、スケジューリングを重視するXさんの体験を基にしている。

1. **目標の設定とカレンダービューの俯瞰**
   - Xさんは、スケジュール管理アプリにログインし、自身の長期的な目標を設定する。
   - アプリのカレンダービューを開き、目標の全体像を俯瞰して確認する。
   - カレンダービューには、目標が大まかに表示され、それに関連するサブゴールやタスクが折りたたまれて表示される。

2. **目標の細分化とタスクの設定**
   - Xさんは、長期的な目標を細分化し、具体的なタスクやマイルストーンに分割する。
   - アプリの目標管理機能を使用し、それぞれの目標に関連するタスクや期限を設定する。
   - 目標とタスクは、関連性を保ちながらカレンダービューに反映される。

3. **日々のタスク管理と進捗追跡**
   - Xさんは、毎日のタスクや予定をアプリのタスクリストに追加する。
   - タスクは目標やサブゴールと関連付けられ、カレンダービューに反映される。
   - タスクの進捗状況を入力し、目標達成までの進捗を可視化する。

4. **通知とリマインダーの受け取り**
   - アプリは、目標の期限や重要なタスクの締切などに関する通知やリマインダーを送信する。
   - Xさんは、通知を受け取りながらタスクの優先順位を調整し、締切を守るためにスケジュールを調整する。

5. **進捗の確認と振り返り**
   - Xさんは、定期的にアプリの進捗ダッシュボードをチェックし、目標の達成度や進捗状況を確認する。
   - 達成したタスクや目標に対して満足感を得るとともに、次のステップや課題に取り組む。


### Problem Statement

Xさんは、現在のスケジュール管理方法では長期的な目標とタスクの関連性や俯瞰が不明確であり、効果的な目標達成やタスク管理に課題を抱えている。
Xさんは、スケジュール管理アプリを利用して目標とタスクの関連性を明確に把握し、進捗を追跡できるようにすることを求めている。

### Hypothesis Statement

ユーザーがスケジュール管理アプリで長期的な目標とタスクの関連性を明確に把握できるようにすることで、効果的な目標達成とタスク管理が向上し、ユーザーの生産性が向上すると予測される。

### Design Problem Statements

1. ユーザーはスケジュール管理アプリを使用しても、目標とタスクの関連性を明確に把握できず、効果的な目標達成とタスク管理が困難である。
2. 現行のスケジュール管理アプリでは、長期的な目標の管理と日々のタスク管理が分断されており、総合的なスケジュールの俯瞰が難しいという問題がある。
3. スケジュール管理アプリにおける通知機能は不十分であり、ユーザーは重要なタスクや予定を見逃すリスクがある。
4. ユーザーはスケジュール管理アプリを使用しても、タスクの優先順位設定や進捗状況の追跡が複雑で煩雑であり、効率的なタスク管理が困難である。

### Value Proposition

このスケジュール管理アプリは、長期的な目標とタスクの関連性を明確に把握できる独自の機能を提供し、効果的な目標達成とタスク管理をサポートする。以下の特徴により、ユーザーの生産性を向上させる。

1. **目標の細分化とタスクの関連性表示:**
   - 長期的な目標を段階的に細分化し、関連するタスクを明確に表示する。
   - ユーザーは大きな目標を小さなタスクに分割し、目標達成に向けた進捗をリアルタイムで把握できる。

2. **統合されたカレンダービュー:**
   - カレンダービューには、目標やタスクが統合されて表示される（パフォーマンス次第）。
   - ユーザーは長期的なスケジュールと日々のタスクを一目で確認でき、予定の管理が容易である。

3. **リマインダーおよび通知機能:**
   - 重要なタスクや予定に対するリマインダーや通知を提供する。
   - ユーザーは見逃しやすい予定や締切を忘れることなく把握し、迅速に対応できる。


## 言語

- 言語: Swift
- フレームワーク: SwiftUI


## 作成予定の機能
...

