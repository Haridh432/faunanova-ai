import '../../models/animal.dart';
import '../../models/animal_intent.dart';
import 'tamil_interpretation_service.dart';

class TamilInterpretationServiceImpl implements TamilInterpretationService {
  @override
  String getTamilInterpretation({
    required AnimalSpecies species,
    required IntentCategory category,
    required String soundType,
  }) {
    switch (category) {
      case IntentCategory.alert:
        return 'எச்சரிக்கை / விழிப்புணர்வு';
      case IntentCategory.attentionSeeking:
        return 'என் மீது கவனம் செலுத்துங்கள்';
      case IntentCategory.distress:
        return 'சிரமம் அல்லது உதவி தேவைப்படுகிறது';
      case IntentCategory.feedingRelated:
        return 'பசி / உணவு தேவைப்படுகிறது';
      case IntentCategory.contentment:
        return 'அமைதி மற்றும் ஆழ்ந்த மகிழ்ச்சி';
      case IntentCategory.contactCalling:
        return 'கூட்டாளிகளை அல்லது உங்களை அழைக்கிறது';
      case IntentCategory.fear:
        return 'பயம் / சற்று இடைவெளி தேவை';
      case IntentCategory.aggression:
        return 'எச்சரிக்கை எல்லை / அருகில் வர வேண்டாம்';
      case IntentCategory.socialInteraction:
        return 'நட்பு மற்றும் விளையாட்டு ஆர்வம்';
      case IntentCategory.matingRelated:
        return 'இனச்சேர்க்கை அழைப்பு ஒலி';
      case IntentCategory.curious:
        return 'ஆர்வம் மற்றும் ஆராயும் நோக்கம்';
      case IntentCategory.unknown:
        return 'தெளிவற்ற ஒலி / சூழல் சத்தம்';
    }
  }

  @override
  String getTamilAdvice({
    required AnimalSpecies species,
    required IntentCategory category,
  }) {
    switch (category) {
      case IntentCategory.alert:
        return 'அமைதியாக நில்லுங்கள். கைகளை உயர்த்தி அசைக்காமல் மிதமான குரலில் பேசுங்கள்.';
      case IntentCategory.attentionSeeking:
        return 'கனிவாகப் பேசி தடவிக் கொடுங்கள். விலங்கு உங்கள் அருகாமையை விரும்புகிறது.';
      case IntentCategory.distress:
        return 'விலங்கின் உடல் நிலையைச் சரிபாருங்கள். காயம் அல்லது தாகம் இருக்கலாம்.';
      case IntentCategory.feedingRelated:
        return 'வழக்கமான உணவு நேரம் அல்லது தண்ணீர் தேவை. சுத்தமான தண்ணீர் வைக்கவும்.';
      case IntentCategory.contentment:
        return 'விலங்கு பாதுகாப்பாக உணர்கிறது. இதே அமைதியான சூழலைத் தொடருங்கள்.';
      case IntentCategory.contactCalling:
        return 'பதில் குரல் எழுப்பி உங்கள் இருப்பை உறுதிப்படுத்துங்கள்.';
      case IntentCategory.fear:
      case IntentCategory.aggression:
        return 'நேரடி கண் தொடர்பைத் தவிர்த்து மெதுவாகப் பின்வாங்கி இடம் கொடுங்கள்.';
      default:
        return 'விலங்கின் இயற்கை இயல்புக்கு மதிப்பளித்து மென்மையாக அணுகுங்கள்.';
    }
  }

  @override
  String getTamilHumanIntent(String intentKey) {
    switch (intentKey.toUpperCase()) {
      case 'COME / CALL':
        return 'இங்கே வா / அழைப்பு';
      case 'FEEDING / FOOD':
        return 'சாப்பிடு / உணவு சமிக்ஞை';
      case 'CALM / SOOTHE':
        return 'அமைதியாக இரு / பயப்படாதே';
      case 'STOP / CAUTION':
        return 'நில் / எச்சரிக்கை சமிக்ஞை';
      case 'AFFECTION / PRAISE':
        return 'நல்ல பிள்ளை / பாசப் பாராட்டு';
      default:
        return intentKey;
    }
  }
}
