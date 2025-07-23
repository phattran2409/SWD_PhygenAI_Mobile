import 'package:phygen/features/ChatAI/model/ExamQuestionModel.dart';

class TestExamData {
  // ✅ Tạo test data cho Vật lý
  static List<ExamQuestionModel> getPhysicsQuestions() {
    return [
      ExamQuestionModel(
        id: '1',
        question: 'Trong dao động điều hòa, gia tốc của vật luôn:',
        className: 'Lớp 12',
        chapterName: 'Dao động cơ',
        topicName: 'Dao động điều hòa',
        difficulty: 1, // 0: Dễ, 1: Trung bình, 2: Khó
        a: 'Cùng chiều với vận tốc',
        b: 'Hướng về vị trí cân bằng',
        c: 'Vuông góc với vận tốc',
        d: 'Không đổi hướng',
        answer: 'B',
      ),
      ExamQuestionModel(
        id: '2',
        question: 'Công thức tính chu kỳ dao động lò xo là:',
        className: 'Lớp 12',
        chapterName: 'Dao động cơ',
        topicName: 'Dao động của con lắc lò xo',
        difficulty: 0,
        a: r'$T = 2\pi\sqrt{\frac{m}{k}}$',
        b: r'$T = 2\pi\sqrt{\frac{k}{m}}$',
        c: r'$T = \pi\sqrt{\frac{m}{k}}$',
        d: r'$T = \sqrt{\frac{m}{k}}$',
        answer: 'A',
      ),
      ExamQuestionModel(
        id: '3',
        question: 'Trong dao động tắt dần, năng lượng của hệ:',
        className: 'Lớp 12',
        chapterName: 'Dao động cơ',
        topicName: 'Dao động tắt dần',
        difficulty: 1,
        a: 'Được bảo toàn',
        b: 'Tăng dần theo thời gian',
        c: 'Giảm dần theo thời gian',
        d: 'Biến đổi tuần hoàn',
        answer: 'C',
      ),
      ExamQuestionModel(
        id: '4',
        question: 'Hiện tượng cộng hưởng xảy ra khi:',
        className: 'Lớp 12',
        chapterName: 'Dao động cơ',
        topicName: 'Dao động cưỡng bức',
        difficulty: 2,
        a: 'Tần số ngoại lực bằng tần số riêng',
        b: 'Tần số ngoại lực lớn hơn tần số riêng',
        c: 'Tần số ngoại lực nhỏ hơn tần số riêng',
        d: 'Biên độ dao động cực đại',
        answer: 'A',
      ),
      ExamQuestionModel(
        id: '5',
        question: 'Đơn vị của tần số góc trong hệ SI là:',
        className: 'Lớp 12',
        chapterName: 'Dao động cơ',
        topicName: 'Các đại lượng đặc trưng',
        difficulty: 0,
        a: 'Hz',
        b: 'rad/s',
        c: 'm/s',
        d: 's',
        answer: 'B',
      ),
    ];
  }
}
