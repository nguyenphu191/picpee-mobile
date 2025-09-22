class OptionItem {
  final String option;
  final String description;

  OptionItem({
    required this.option,
    this.description = 'Description of addons',
  });
}

class ServiceItem {
  final String title;
  final String category;
  final String description;
  final List<OptionItem> options;

  ServiceItem({
    required this.title,
    required this.category,
    required this.description,
    required this.options,
  });
}

List<ServiceItem> servicesData = [
  // IMAGE ENHANCEMENT
  ServiceItem(
    title: 'Single Exposure',
    category: 'IMAGE ENHANCEMENT',
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
    title: 'Blended Brackets (HDR)',
    category: 'IMAGE ENHANCEMENT',
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
    title: 'Flambient',
    category: 'IMAGE ENHANCEMENT',
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
    title: '360° Image Enhancement',
    category: 'IMAGE ENHANCEMENT',
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
    title: 'Virtual Staging',
    category: 'VIRTUAL STAGING',
    description:
        'Using digital furniture, experts transform empty spaces into exquisitely decorated rooms. Each piece is styled to match the aesthetic of your home.',

    options: [],
  ),
  ServiceItem(
    title: 'Remodel',
    category: 'VIRTUAL STAGING',
    description:
        'Sellers will renovate their home from replacing floors, repainting walls, renovating the kitchen,... realistically, helping buyers visualize their future home.',
    options: [],
  ),
  ServiceItem(
    title: '360° Image',
    category: 'VIRTUAL STAGING',
    description:
        'A panoramic stage with realistic furniture and decor. Delivering a complete, immersive experience in the room.',
    options: [],
  ),

  // DAY TO DUSK
  ServiceItem(
    title: 'Day to Dusk',
    category: 'DAY TO DUSK',
    description:
        'Turn daytime photos into romantic sunsets by changing the sky, adding light, and adjusting shadows. This way, experts create a warm space that tells a compelling story.',
    options: [],
  ),

  // DAY TO TWILIGHT
  ServiceItem(
    title: 'Day to Twilight',
    category: 'DAY TO TWILIGHT',
    description:
        'Shoot your property at dusk with subtle edits for warm, inviting lighting. This enhances the architectural charm and makes it stand out in the market.',
    options: [
      OptionItem(option: 'Blend Flash Exposures', description: ""),
      OptionItem(option: 'Composite Lighting', description: ""),
    ],
  ),

  // OBJECT REMOVAL
  ServiceItem(
    title: '1-4 Items',
    category: 'OBJECT REMOVAL',
    description:
        'Remove small, distracting objects from your photos. It could be a flip flop near the pool, a stray toothbrush in the sink, or a trash can in the driveway.',
    options: [],
  ),
  ServiceItem(
    title: 'Room Cleaning',
    category: 'OBJECT REMOVAL',
    description:
        'Digitally clean rooms to highlight their best features, transforming cluttered rooms into clean environments. From there, we bring out the true potential and charm of any space.',
    options: [],
  ),

  // CHANGING SEASONS
  ServiceItem(
    title: 'Changing Seasons',
    category: 'CHANGING SEASONS',
    description:
        'Transform seasonal images to reflect the property at any time of year. Replace overcast skies and bare trees with clear blue skies and lush vegetation.',
    options: [],
  ),

  // WATER IN POOL
  ServiceItem(
    title: 'Water In Pool',
    category: 'WATER IN POOL',
    description:
        'Experienced providers skillfully remove dirt, debris and turbidity to restore a clear, attractive pool. A sparkling pool reflects the luxury and class of the property.',
    options: [],
  ),

  // LAWN REPLACEMENT
  ServiceItem(
    title: 'Lawn Replacement',
    category: 'LAWN REPLACEMENT',
    description:
        'The service provider will transform a dry, patchy lawn into a vibrant, green lawn. A fresh lawn makes a strong first impression and enhances the overall appearance of your listing.',
    options: [],
  ),

  // RAIN TO SHINE
  ServiceItem(
    title: 'Rain to Shine',
    category: 'RAIN TO SHINE',
    description:
        "Signs of bad weather like dark clouds, wet roads, or snow are cleverly handled to transform the scene into a beautiful sunny day. This way, you don't have to postpone the shoot or reshoot.",
    options: [],
  ),

  // FLOOR PLANS
  ServiceItem(
    title: 'Custom 2D',
    category: 'FLOOR PLANS',
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
    title: 'Custom 3D',
    category: 'FLOOR PLANS',
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
    title: 'Property Videos',
    category: 'PROPERTY VIDEOS SERVICES',
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
    title: 'Walkthrough Video',
    category: 'PROPERTY VIDEOS SERVICES',
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
    title: 'Reels',
    category: 'PROPERTY VIDEOS SERVICES',
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
    title: 'Slideshows',
    category: 'PROPERTY VIDEOS SERVICES',
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
    title: 'Individual',
    category: 'HEADSHOTS SERVICES',
    description:
        'Enhance your portraits with professional edits while retaining personality. Perfect for polished, unique portraits.',
    options: [],
  ),
  ServiceItem(
    title: 'Team',
    category: 'HEADSHOTS SERVICES',
    description:
        'Combine up to 8 people into one cohesive group photo. Each person brings their own beauty while still creating harmony and balance.',
    options: [],
  ),
  ServiceItem(
    title: 'Add Person',
    category: 'HEADSHOTS SERVICES',
    description:
        'Insert people individually into a group photo using the images provided. Seamless editing makes the final result look natural.',
    options: [],
  ),
  ServiceItem(
    title: 'Remove Person',
    category: 'HEADSHOTS SERVICES',
    description:
        'Remove unwanted people from your photo while keeping the composition neutral and professional.',
    options: [],
  ),
  ServiceItem(
    title: 'Background Replacement',
    category: 'HEADSHOTS SERVICES',
    description:
        'Change the background to anything from an office to a park, customize the look to your needs.',
    options: [],
  ),
  ServiceItem(
    title: 'Cut Outs',
    category: 'HEADSHOTS SERVICES',
    description:
        'Quickly remove the background from your photos for easy editing. Perfect for web, print, and custom designs.',
    options: [],
  ),
  ServiceItem(
    title: 'Change Color',
    category: 'HEADSHOTS SERVICES',
    description:
        'Adjust color, contrast, and lighting with just one click. Create mood and enhance the visual impact of any image.',
    options: [],
  ),
];
