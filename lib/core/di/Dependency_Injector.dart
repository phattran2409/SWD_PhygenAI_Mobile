import 'package:get_it/get_it.dart';
import 'package:phygen/core/services/API_Client.dart';

abstract class DependencyInjector {
   Future<void> register(GetIt sl); // Initialize the dependency injector
}

class DependencyManager {
  static final GetIt sl = GetIt.instance;
  static final List<DependencyInjector> _injectors = [];  
  
  static void addInjector(DependencyInjector injector) {
    _injectors.add(injector);
  } 
  
  static Future<void> init() async {
    try {
      // ✅ Reset if already registered (for hot reload)
      if (sl.isRegistered<ApiClient>()) {
        print('🔄 Resetting GetIt...');
        await sl.reset();
      }

      // ✅ Register all injectors
      for (final injector in _injectors) {
        await injector.register(sl);
      }

      print('✅ All dependencies registered successfully');
    } catch (e, stackTrace) {
      print('❌ DI Error: $e');
      print('📍 Stack trace: $stackTrace');
      rethrow;
    }
  }
}