import 'package:picpee_mobile/core/images/app_image.dart';

class OptionItem {
  final String option;
  final String description;

  OptionItem({
    required this.option,
    this.description = 'Description of addons',
  });
}

class ServiceItem {
  int id;
  String title;
  String category;
  String image;
  String description;
  List<OptionItem> options;

  ServiceItem({
    required this.id,
    required this.title,
    required this.category,
    this.image = '',
    required this.description,
    required this.options,
  });
}

List<ServiceItem> servicesData = [
  // IMAGE ENHANCEMENT
  ServiceItem(
    id: 2,
    title: 'Single Exposure',
    category: 'IMAGE ENHANCEMENT',
    image: AppImages.SingleExportIcon,
    description:
        'Convert a single exposure or pre-blended exposure into a professional, realistic image. Adjust color, contrast, and lighting for a polished, flawless look.',
    options: [
      OptionItem(option: 'Fireplace Composite'),
      OptionItem(option: 'Sky Replacement'),
      OptionItem(option: 'TV Screen Replacement'),
      OptionItem(option: 'Minor Blemish Removal'),
      OptionItem(option: 'Resize to MLS', description: 'no extra fee'),
      OptionItem(option: 'Add watermark', description: 'no extra fee'),
      OptionItem(option: 'Send 2 versions', description: 'no extra fee'),
      OptionItem(option: 'Add logo', description: 'no extra fee'),
    ],
  ),
  ServiceItem(
    id: 3,
    title: 'Blended Brackets (HDR)',
    category: 'IMAGE ENHANCEMENT',
    image: AppImages.HDRIcon,
    description:
        'Combine three or more exposures to create a vibrant, sharp image with enhanced depth and brightness. Often chosen by real estate photographers.',
    options: [
      OptionItem(option: 'Fireplace Composite'),
      OptionItem(option: 'Sky Replacement'),
      OptionItem(option: 'TV Screen Replacement'),
      OptionItem(option: 'Minor Blemish Removal'),
      OptionItem(option: 'Resize to MLS', description: 'no extra fee'),
      OptionItem(option: 'Add watermark', description: 'no extra fee'),
      OptionItem(option: 'Send 2 versions', description: 'no extra fee'),
      OptionItem(option: 'Add logo', description: 'no extra fee'),
    ],
  ),
  ServiceItem(
    id: 4,
    title: 'Flambient',
    category: 'IMAGE ENHANCEMENT',
    image: AppImages.FlambientIcon,
    description:
        'Combine flash and natural light to create artistic, emotional photos. This technique creates striking images, perfect for luxury real estate listings.',
    options: [
      OptionItem(option: 'Fireplace Composite'),
      OptionItem(option: 'Sky Replacement'),
      OptionItem(option: 'TV Screen Replacement'),
      OptionItem(option: 'Minor Blemish Removal'),
      OptionItem(option: 'Resize to MLS', description: 'no extra fee'),
      OptionItem(option: 'Add watermark', description: 'no extra fee'),
      OptionItem(option: 'Send 2 versions', description: 'no extra fee'),
      OptionItem(option: 'Add logo', description: 'no extra fee'),
    ],
  ),
  ServiceItem(
    id: 6,
    title: '360° Image Enhancement',
    category: 'IMAGE ENHANCEMENT',
    image: AppImages.Image360EnhanceIcon,
    description:
        'Improve 360° photos by balancing exposure and enhancing clarity. Showcase details from every angle for a seamless experience.',
    options: [
      OptionItem(option: 'Fireplace Composite'),
      OptionItem(option: 'Sky Replacement'),
      OptionItem(option: 'TV Screen Replacement'),
      OptionItem(option: 'Minor Blemish Removal'),
      OptionItem(option: 'Resize to MLS', description: 'no extra fee'),
      OptionItem(option: 'Add watermark', description: 'no extra fee'),
      OptionItem(option: 'Send 2 versions', description: 'no extra fee'),
      OptionItem(option: 'Add logo', description: 'no extra fee'),
    ],
  ),

  // VIRTUAL STAGING
  ServiceItem(
    id: 7,
    title: 'Virtual Staging',
    category: 'VIRTUAL STAGING',
    image: AppImages.VirtualStaggingIcon,
    description:
        'Using digital furniture, experts transform empty spaces into exquisitely decorated rooms. Each piece is styled to match the aesthetic of your home.',

    options: [],
  ),
  ServiceItem(
    id: 8,
    title: 'Remodel',
    category: 'VIRTUAL STAGING',
    image: AppImages.RemodelIcon,
    description:
        'Sellers will renovate their home from replacing floors, repainting walls, renovating the kitchen,... realistically, helping buyers visualize their future home.',
    options: [],
  ),
  ServiceItem(
    id: 9,
    title: '360° Image',
    category: 'VIRTUAL STAGING',
    image: AppImages.Image360Icon,
    description:
        'A panoramic stage with realistic furniture and decor. Delivering a complete, immersive experience in the room.',
    options: [],
  ),

  // DAY TO DUSK
  ServiceItem(
    id: 10,
    title: 'Day to Dusk',
    category: 'DAY TO DUSK',
    image: AppImages.DayToDuckIcon,
    description:
        'Turn daytime photos into romantic sunsets by changing the sky, adding light, and adjusting shadows. This way, experts create a warm space that tells a compelling story.',
    options: [],
  ),

  // DAY TO TWILIGHT
  ServiceItem(
    id: 11,
    title: 'Day to Twilight',
    category: 'DAY TO TWILIGHT',
    image: AppImages.DayToTwilightIcon,
    description:
        'Shoot your property at dusk with subtle edits for warm, inviting lighting. This enhances the architectural charm and makes it stand out in the market.',
    options: [
      OptionItem(option: 'Blend Flash Exposures', description: ""),
      OptionItem(option: 'Composite Lighting', description: ""),
    ],
  ),

  // OBJECT REMOVAL
  ServiceItem(
    id: 12,
    title: '1-4 Items',
    category: 'OBJECT REMOVAL',
    image: AppImages.CleanIcon,
    description:
        'Remove small, distracting objects from your photos. It could be a flip flop near the pool, a stray toothbrush in the sink, or a trash can in the driveway.',
    options: [],
  ),
  ServiceItem(
    id: 13,
    title: 'Room Cleaning',
    category: 'OBJECT REMOVAL',
    image: AppImages.CleanIcon,
    description:
        'Digitally clean rooms to highlight their best features, transforming cluttered rooms into clean environments. From there, we bring out the true potential and charm of any space.',
    options: [],
  ),

  // CHANGING SEASONS
  ServiceItem(
    id: 14,
    title: 'Changing Seasons',
    category: 'CHANGING SEASONS',
    image: AppImages.ChangeSessionIcon,
    description:
        'Transform seasonal images to reflect the property at any time of year. Replace overcast skies and bare trees with clear blue skies and lush vegetation.',
    options: [],
  ),

  // WATER IN POOL
  ServiceItem(
    id: 15,
    title: 'Water In Pool',
    category: 'WATER IN POOL',
    image: AppImages.WaterInPoolIcon,
    description:
        'Experienced providers skillfully remove dirt, debris and turbidity to restore a clear, attractive pool. A sparkling pool reflects the luxury and class of the property.',
    options: [],
  ),

  // LAWN REPLACEMENT
  ServiceItem(
    id: 16,
    title: 'Lawn Replacement',
    category: 'LAWN REPLACEMENT',
    image: AppImages.LawnReplacementIcon,
    description:
        'The service provider will transform a dry, patchy lawn into a vibrant, green lawn. A fresh lawn makes a strong first impression and enhances the overall appearance of your listing.',
    options: [],
  ),

  // RAIN TO SHINE
  ServiceItem(
    id: 17,
    title: 'Rain to Shine',
    category: 'RAIN TO SHINE',
    image: AppImages.RainToShineIcon,
    description:
        "Signs of bad weather like dark clouds, wet roads, or snow are cleverly handled to transform the scene into a beautiful sunny day. This way, you don't have to postpone the shoot or reshoot.",
    options: [],
  ),

  // FLOOR PLANS
  ServiceItem(
    id: 18,
    title: 'Custom 2D',
    category: 'FLOOR PLANS',
    image: AppImages.Custom2dIcon,
    description:
        'Turn sketches into professional, branded 2D floor plans with dimensions and colors. Highlight layout, flow, and functionality with clear visuals.',
    options: [
      OptionItem(option: 'Colorized', description: "Full size and Limit size"),
      OptionItem(option: 'Textured', description: "no extra fee"),
      OptionItem(
        option: 'Fixed Furniture',
        description: "Description of addons",
      ),
      OptionItem(
        option: 'Staged Furniture',
        description: "Description of addons",
      ),
    ],
  ),
  ServiceItem(
    id: 31,
    title: 'Custom 3D',
    category: 'FLOOR PLANS',
    image: AppImages.Custom3dIcon,
    description:
        'Design realistic 3D floor plans to visualize spaces and lifestyles. Ideal for vacation and luxury listings. Sellers can also customize the interior to freshen up the look of the home.',
    options: [
      OptionItem(option: 'Colored & Textured', description: "no extra fee"),
      OptionItem(
        option: 'Fixed Furniture',
        description: "Description of addons",
      ),
      OptionItem(
        option: 'Staged Furniture',
        description: "Description of addons",
      ),
    ],
  ),

  // PROPERTY VIDEOS SERVICES
  ServiceItem(
    id: 20,
    title: 'Property Videos',
    category: 'PROPERTY VIDEOS SERVICES',
    image: AppImages.PropertyIcon,
    description:
        'Turn raw footage into cinematic real estate videos, with smooth transitions, synchronized voiceover and music, delivering a professional and emotional audiovisual experience.',
    options: [
      OptionItem(option: 'Music', description: 'no extra fee'),
      OptionItem(option: 'Sound Effects', description: 'Description of addons'),
      OptionItem(option: 'Voiceover', description: 'Description of addons'),
      OptionItem(option: 'Titles', description: 'Full size and Limit sizee'),
      OptionItem(option: 'Branding', description: 'no extra fee'),
      OptionItem(
        option: 'Agent Intro/ Outro',
        description: 'Description of addons',
      ),
      OptionItem(option: 'Captions', description: 'Description of addons'),
      OptionItem(option: 'Lot Lines Overlay', description: 'no extra fee'),
      OptionItem(
        option: 'Site Plan Overlay',
        description: 'Description of addons',
      ),
      OptionItem(
        option: 'Features Overlay',
        description: 'Description of addons',
      ),
    ],
  ),
  ServiceItem(
    id: 21,
    title: 'Walkthrough Video',
    category: 'PROPERTY VIDEOS SERVICES',
    image: AppImages.WalkthroughIcon,
    description:
        'Guide viewers through your home with continuous, seamless footage. Add effects and voiceover for an immersive experience.',
    options: [
      OptionItem(option: 'Music', description: 'no extra fee'),
      OptionItem(option: 'Sound Effects', description: 'Description of addons'),
      OptionItem(option: 'Voiceover', description: 'Description of addons'),
      OptionItem(option: 'Titles', description: 'Full size and Limit sizee'),
      OptionItem(option: 'Branding', description: 'no extra fee'),
      OptionItem(
        option: 'Agent Intro/ Outro',
        description: 'Description of addons',
      ),
      OptionItem(option: 'Captions', description: 'Description of addons'),
      OptionItem(option: 'Lot Lines Overlay', description: 'no extra fee'),
      OptionItem(
        option: 'Site Plan Overlay',
        description: 'Description of addons',
      ),
      OptionItem(
        option: 'Features Overlay',
        description: 'Description of addons',
      ),
    ],
  ),
  ServiceItem(
    id: 22,
    title: 'Reels',
    category: 'PROPERTY VIDEOS SERVICES',
    image: AppImages.ReelsIcon,
    description:
        'Provider creates short (around 10-30 seconds), vertical videos with animations and music. Perfect for grabbing attention on social media.',
    options: [
      OptionItem(option: 'Music', description: 'no extra fee'),
      OptionItem(option: 'Sound Effects', description: 'Description of addons'),
      OptionItem(option: 'Voiceover', description: 'Description of addons'),
      OptionItem(option: 'Titles', description: 'Full size and Limit sizee'),
      OptionItem(option: 'Branding', description: 'no extra fee'),
      OptionItem(
        option: 'Agent Intro/ Outro',
        description: 'Description of addons',
      ),
      OptionItem(option: 'Captions', description: 'Description of addons'),
      OptionItem(option: 'Lot Lines Overlay', description: 'no extra fee'),
      OptionItem(
        option: 'Site Plan Overlay',
        description: 'Description of addons',
      ),
      OptionItem(
        option: 'Features Overlay',
        description: 'Description of addons',
      ),
    ],
  ),
  ServiceItem(
    id: 23,
    title: 'Slideshows',
    category: 'PROPERTY VIDEOS SERVICES',
    image: AppImages.SlideShowIcon,
    description:
        'Convert still photos into engaging videos with effects, graphics, voiceovers, and music. Leverage stock images for real estate marketing.',
    options: [
      OptionItem(option: 'Music', description: 'no extra fee'),
      OptionItem(option: 'Sound Effects', description: 'Description of addons'),
      OptionItem(option: 'Voiceover', description: 'Description of addons'),
      OptionItem(option: 'Titles', description: 'Full size and Limit sizee'),
      OptionItem(option: 'Branding', description: 'no extra fee'),
      OptionItem(
        option: 'Agent Intro/ Outro',
        description: 'Description of addons',
      ),
      OptionItem(option: 'Captions', description: 'Description of addons'),
      OptionItem(option: 'Lot Lines Overlay', description: 'no extra fee'),
      OptionItem(
        option: 'Site Plan Overlay',
        description: 'Description of addons',
      ),
      OptionItem(
        option: 'Features Overlay',
        description: 'Description of addons',
      ),
    ],
  ),

  // HEADSHOTS SERVICES
  ServiceItem(
    id: 24,
    title: 'Individual',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.IndividualIcon,
    description:
        'Enhance your portraits with professional edits while retaining personality. Perfect for polished, unique portraits.',
    options: [],
  ),
  ServiceItem(
    id: 25,
    title: 'Team',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.TeamIcon,
    description:
        'Combine up to 8 people into one cohesive group photo. Each person brings their own beauty while still creating harmony and balance.',
    options: [],
  ),
  ServiceItem(
    id: 26,
    title: 'Add Person',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.AddPersonIcon,
    description:
        'Insert people individually into a group photo using the images provided. Seamless editing makes the final result look natural.',
    options: [],
  ),
  ServiceItem(
    id: 27,
    title: 'Remove Person',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.RemovePersonIcon,
    description:
        'Remove unwanted people from your photo while keeping the composition neutral and professional.',
    options: [],
  ),
  ServiceItem(
    id: 28,
    title: 'Background Replacement',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.BackgroundReplaceIcon,
    description:
        'Change the background to anything from an office to a park, customize the look to your needs.',
    options: [],
  ),
  ServiceItem(
    id: 29,
    title: 'Cut Outs',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.CutsOutIcon,
    description:
        'Quickly remove the background from your photos for easy editing. Perfect for web, print, and custom designs.',
    options: [],
  ),
  ServiceItem(
    id: 30,
    title: 'Change Color',
    category: 'HEADSHOTS SERVICES',
    image: AppImages.ChangeColorIcon,
    description:
        'Adjust color, contrast, and lighting with just one click. Create mood and enhance the visual impact of any image.',
    options: [],
  ),
];
List<Map<String, String>> getTitleDescriptionPairs() {
  return servicesData
      .map(
        (service) => {
          'title': service.title,
          'description': service.description,
        },
      )
      .toList();
}
