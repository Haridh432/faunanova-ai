import '../../models/animal.dart';
import '../../models/animal_intent.dart';
import 'animal_intent_service.dart';

class AnimalIntentServiceImpl implements AnimalIntentService {
  @override
  List<AnimalIntent> getSpeciesIntents(AnimalSpecies species) {
    switch (species) {
      case AnimalSpecies.dog:
        return [
          const AnimalIntent(
            category: IntentCategory.alert,
            species: AnimalSpecies.dog,
            intentEn: 'Alert / Attention',
            intentTa: 'எச்சரிக்கை / விழிப்புணர்வு',
            behaviorDescriptionEn: 'The dog has noticed unusual motion or an unfamiliar presence.',
            behaviorDescriptionTa: 'நாய் புதிய அசைவையோ அல்லது அறிமுகமில்லாத நபரையோ கவனித்துள்ளது.',
            recommendedResponseEn: 'Speak in a calm voice, do not make sudden running gestures.',
            recommendedResponseTa: 'அமைதியான குரலில் பேசுங்கள், திடீரென ஓட வேண்டாம்.',
            signalFrequencyProfile: '1000Hz - 1500Hz Pulse',
          ),
          const AnimalIntent(
            category: IntentCategory.attentionSeeking,
            species: AnimalSpecies.dog,
            intentEn: 'Attention Seeking / Playful',
            intentTa: 'கவனம் ஈர்ப்பு / விளையாட்டு ஆர்வம்',
            behaviorDescriptionEn: 'Seeking human interaction, wanting to play or go outside.',
            behaviorDescriptionTa: 'மனிதர்களுடன் பழக விரும்புகிறது, விளையாட அல்லது வெளியே செல்ல ஆசைப்படுகிறது.',
            recommendedResponseEn: 'Offer gentle eye contact and a cheerful tone.',
            recommendedResponseTa: 'மகிழ்ச்சியான குரலில் நலம் விசாரியுங்கள்.',
            signalFrequencyProfile: '1200Hz Upward Sweep',
          ),
          const AnimalIntent(
            category: IntentCategory.distress,
            species: AnimalSpecies.dog,
            intentEn: 'Mild Distress / Seeking Comfort',
            intentTa: 'சிறு பயம் / ஆறுதல் தேடுதல்',
            behaviorDescriptionEn: 'Feeling anxious, uncomfortable, or seeking reassurance.',
            behaviorDescriptionTa: 'பதட்டமாக உணர்கிறது அல்லது ஆறுதலை எதிர்பார்க்கிறது.',
            recommendedResponseEn: 'Approach gently from the side and avoid loud noises.',
            recommendedResponseTa: 'மெதுவாக அணுகுங்கள், உரத்த ஒலிகளைத் தவிர்க்கவும்.',
            signalFrequencyProfile: '250Hz Low Soothing Hum',
          ),
          const AnimalIntent(
            category: IntentCategory.feedingRelated,
            species: AnimalSpecies.dog,
            intentEn: 'Hunger / Food Request',
            intentTa: 'பசி / உணவு தேவை',
            behaviorDescriptionEn: 'Reminding human of regular feeding time or smelling food.',
            behaviorDescriptionTa: 'உணவு நேரம் வந்துவிட்டது என்பதை நினைவூட்டுகிறது.',
            recommendedResponseEn: 'Check food and water bowls.',
            recommendedResponseTa: 'உணவு மற்றும் தண்ணீர் கிண்ணங்களைச் சரிபார்க்கவும்.',
            signalFrequencyProfile: '650Hz Double Chirp',
          ),
        ];

      case AnimalSpecies.cat:
        return [
          const AnimalIntent(
            category: IntentCategory.attentionSeeking,
            species: AnimalSpecies.cat,
            intentEn: 'Attention Seeking / Greeting',
            intentTa: 'கவனம் ஈர்ப்பு / அன்பான வணக்கம்',
            behaviorDescriptionEn: 'Greeting familiar humans and asking for petting or companionship.',
            behaviorDescriptionTa: 'அன்புடன் நலம் விசாரிக்கிறது, தடவிக்கொடுக்க விரும்புகிறது.',
            recommendedResponseEn: 'Slowly blink and extend your finger for sniffing.',
            recommendedResponseTa: 'மெதுவாகக் கண் சிமிட்டி உங்கள் விரலை மோப்பம் பிடிக்கக் காட்டுங்கள்.',
            signalFrequencyProfile: '3200Hz Soft Chirp',
          ),
          const AnimalIntent(
            category: IntentCategory.contentment,
            species: AnimalSpecies.cat,
            intentEn: 'Contentment / Relaxation',
            intentTa: 'திருப்தி / அமைதியான மகிழ்ச்சி',
            behaviorDescriptionEn: 'Rhythmic purring showing absolute comfort, safety, and happiness.',
            behaviorDescriptionTa: 'முழுமையான அமைதியிலும் மகிழ்ச்சியிலும் பூனை உறுமல் செய்கிறது.',
            recommendedResponseEn: 'Continue gentle petting along cheek and chin.',
            recommendedResponseTa: 'கன்னத்தில் மென்மையாகத் தடவிக் கொடுங்கள்.',
            signalFrequencyProfile: '35Hz Rhythmic Hum',
          ),
          const AnimalIntent(
            category: IntentCategory.feedingRelated,
            species: AnimalSpecies.cat,
            intentEn: 'Feeding Demand / Food Call',
            intentTa: 'உணவு தேவை / பசி ஒலி',
            behaviorDescriptionEn: 'Higher pitch meow specifically calibrated to prompt human response for food.',
            behaviorDescriptionTa: 'உணவு வேண்டி மனிதர்களைத் தூண்டும் உயர் தொனி ஒலி.',
            recommendedResponseEn: 'Provide fresh wet/dry cat meal and clean drinking water.',
            recommendedResponseTa: 'சுத்தமான உணவு மற்றும் தண்ணீர் வையுங்கள்.',
            signalFrequencyProfile: '1800Hz Staccato Tone',
          ),
          const AnimalIntent(
            category: IntentCategory.fear,
            species: AnimalSpecies.cat,
            intentEn: 'Defensive Boundary / Fear',
            intentTa: 'தற்காப்பு எல்லை / பயம்',
            behaviorDescriptionEn: 'Demanding space; feels threatened by approaching object or animal.',
            behaviorDescriptionTa: 'பயந்துபோய் உள்ளது; அருகில் செல்லாமல் இடைவெளி விடவும்.',
            recommendedResponseEn: 'Step back, give physical space, lower your posture.',
            recommendedResponseTa: 'பின்வாங்கி இடைவெளி கொடுங்கள், அமைதியாக இருங்கள்.',
            signalFrequencyProfile: 'White Noise Low Sweep',
          ),
        ];

      case AnimalSpecies.cow:
        return [
          const AnimalIntent(
            category: IntentCategory.contactCalling,
            species: AnimalSpecies.cow,
            intentEn: 'Contact Calling / Herd Communication',
            intentTa: 'கூட்டாளிகளை அழைத்தல் / தொடர்பு',
            behaviorDescriptionEn: 'Low frequency resonant vocalization checking in on companions or caretaker.',
            behaviorDescriptionTa: 'கூட்டாளிகள் அல்லது பராமரிப்பாளரை அமைதியாகத் தேடும் ஒலி.',
            recommendedResponseEn: 'Respond with a calm, steady human voice.',
            recommendedResponseTa: 'மென்மையான நிலையான குரலில் பதில் கூறுங்கள்.',
            signalFrequencyProfile: '180Hz Resonant Drone',
          ),
          const AnimalIntent(
            category: IntentCategory.feedingRelated,
            species: AnimalSpecies.cow,
            intentEn: 'Feeding / Water Request',
            intentTa: 'தீவனம் / தண்ணீர் தேவை',
            behaviorDescriptionEn: 'Continuous rhythmic moo requesting fodder, green grass, or fresh water.',
            behaviorDescriptionTa: 'தீவனம் அல்லது புதிய தண்ணீர் கேட்டு குரல் எழுப்புகிறது.',
            recommendedResponseEn: 'Check trough for fresh water and green fodder.',
            recommendedResponseTa: 'பசுந்தீவனம் மற்றும் தண்ணீர் தொட்டியைச் சரிபார்க்கவும்.',
            signalFrequencyProfile: '220Hz Pulse Tone',
          ),
          const AnimalIntent(
            category: IntentCategory.distress,
            species: AnimalSpecies.cow,
            intentEn: 'Distress / Calf Search',
            intentTa: 'சிரமம் / கன்றைத் தேடுதல்',
            behaviorDescriptionEn: 'Higher pitch maternal call searching for her calf or signaling discomfort.',
            behaviorDescriptionTa: 'கன்றைத் தேடும் அல்லது உடல் உபாதையைக் குறிக்கும் ஒலி.',
            recommendedResponseEn: 'Inspect living conditions and reassure gently.',
            recommendedResponseTa: 'கன்றை அருகில் கொண்டுவாருங்கள் அல்லது தேவையை கவனியுங்கள்.',
            signalFrequencyProfile: '400Hz Warm Call',
          ),
        ];

      case AnimalSpecies.bird:
        return [
          const AnimalIntent(
            category: IntentCategory.alert,
            species: AnimalSpecies.bird,
            intentEn: 'Predator Alert / Flight Warning',
            intentTa: 'எச்சரிக்கை ஒலி / ஆபத்து அறிவிப்பு',
            behaviorDescriptionEn: 'Sharp alarm trill alerting flock members of cats, raptors, or threats.',
            behaviorDescriptionTa: 'பூனைகள் அல்லது வேட்டையாடும் பறவைகள் பற்றி கூட்டத்திற்கு எச்சரிக்கிறது.',
            recommendedResponseEn: 'Avoid sudden arm movements overhead.',
            recommendedResponseTa: 'திடீரென கைகளை அசைக்க வேண்டாம்.',
            signalFrequencyProfile: '3500Hz Rapid Staccato',
          ),
          const AnimalIntent(
            category: IntentCategory.socialInteraction,
            species: AnimalSpecies.bird,
            intentEn: 'Territorial / Social Chirp',
            intentTa: 'கூட்டுறவுப் பாட்டு / அமைதியான குரல்',
            behaviorDescriptionEn: 'Singing to demarcate territory and signal contentment to mates.',
            behaviorDescriptionTa: 'மகிழ்ச்சியாகப் பாடி தன் எல்லை மற்றும் இருப்பை உறுதிசெய்கிறது.',
            recommendedResponseEn: 'Enjoy the natural acoustic environment.',
            recommendedResponseTa: 'அமைதியாகக் கேட்டு மகிழுங்கள்.',
            signalFrequencyProfile: '2800Hz Harmonic Whistle',
          ),
        ];

      case AnimalSpecies.goat:
        return [
          const AnimalIntent(
            category: IntentCategory.contactCalling,
            species: AnimalSpecies.goat,
            intentEn: 'Social Calling / Herd Check',
            intentTa: 'கூட்டாளிகளைத் தேடும் கத்தல்',
            behaviorDescriptionEn: 'Vocal bleat checking where other goats or herder are situated.',
            behaviorDescriptionTa: 'மற்ற ஆடுகள் அல்லது மேய்ப்பாளர் எங்கு இருக்கிறார் என்பதைத் தேடுகிறது.',
            recommendedResponseEn: 'Walk into visual range.',
            recommendedResponseTa: 'அதன் பார்வைக்குத் தெரியும் தூரத்திற்கு வாருங்கள்.',
            signalFrequencyProfile: '450Hz Tremolo Bleat',
          ),
          const AnimalIntent(
            category: IntentCategory.feedingRelated,
            species: AnimalSpecies.goat,
            intentEn: 'Appetite / Foraging Request',
            intentTa: 'மேய்ச்சல் / உணவு தேவை',
            behaviorDescriptionEn: 'Eager bleat asking for grains, leaves, or grazing access.',
            behaviorDescriptionTa: 'இலை தழைகள் அல்லது தீவனம் வேண்டி உற்சாகமாகக் கத்துகிறது.',
            recommendedResponseEn: 'Offer fresh neem or acacia leaves.',
            recommendedResponseTa: 'புதிய வேப்பிலை அல்லது தீவனம் வழங்குங்கள்.',
            signalFrequencyProfile: '520Hz Pulsed Whistle',
          ),
        ];

      case AnimalSpecies.elephant:
        return [
          const AnimalIntent(
            category: IntentCategory.contactCalling,
            species: AnimalSpecies.elephant,
            intentEn: 'Infrasonic Social Rumble',
            intentTa: 'ஆழ்நிலை அதிர்வு / கூட்டமைப்பு அழைப்பு',
            behaviorDescriptionEn: 'Low frequency infrasound traveling kilometers to coordinate herd movement.',
            behaviorDescriptionTa: 'பல கிலோமீட்டர்கள் பயணிக்கக்கூடிய அதிர்வு மூலம் கூட்டத்தை வழிநடத்துகிறது.',
            recommendedResponseEn: 'Maintain respectful distance (>50m).',
            recommendedResponseTa: 'பாதுகாப்பான தொலைவில் (50 மீட்டருக்கு மேல்) நில்லுங்கள்.',
            signalFrequencyProfile: '18Hz Infrasound Tone',
          ),
          const AnimalIntent(
            category: IntentCategory.alert,
            species: AnimalSpecies.elephant,
            intentEn: 'Trumpet / High Alert',
            intentTa: 'பிளிறல் / தீவிர விழிப்புணர்வு',
            behaviorDescriptionEn: 'Loud trumpet signaling surprise, danger, or commanding attention.',
            behaviorDescriptionTa: 'திடீர் ஆபத்து அல்லது கவன ஈர்ப்பிற்கான பலத்த பிளிறல்.',
            recommendedResponseEn: 'Calmly retreat to safe enclosure or vehicle.',
            recommendedResponseTa: 'உடனடியாக பாதுகாப்பான இடத்திற்கு ஒதுங்குங்கள்.',
            signalFrequencyProfile: '1200Hz Brass Acoustic',
          ),
        ];
    }
  }

  @override
  Future<AnimalIntent> predictIntent({
    required AnimalSpecies species,
    required String soundType,
    Map<String, dynamic>? acousticContext,
  }) async {
    final list = getSpeciesIntents(species);
    final lower = soundType.toLowerCase();

    for (final intent in list) {
      if (lower.contains('alert') || lower.contains('bark')) {
        if (intent.category == IntentCategory.alert) return intent;
      } else if (lower.contains('purr')) {
        if (intent.category == IntentCategory.contentment) return intent;
      } else if (lower.contains('whimper') || lower.contains('distress')) {
        if (intent.category == IntentCategory.distress) return intent;
      } else if (lower.contains('meow') || lower.contains('chirp')) {
        if (intent.category == IntentCategory.attentionSeeking) return intent;
      } else if (lower.contains('moo') || lower.contains('call')) {
        if (intent.category == IntentCategory.contactCalling || intent.category == IntentCategory.feedingRelated) {
          return intent;
        }
      }
    }

    return list.first;
  }
}
