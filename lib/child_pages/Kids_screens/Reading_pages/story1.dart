import 'package:flutter/material.dart';

class Story1Page extends StatelessWidget {
  // Replace this with your list of images and descriptions
  final List<Map<String, String>> storyData = [
    {
      'image': 'assets/story_1/image11.png',
      'description':
          'Practice counting to 60. Kids need to be able to count to 60 (in the correct order) in order to tell time. Have your child write down the numbers 1 through 60 on a piece of paper. As they write each number, have them recite the number as well. Post this piece of paper on a wall and have them recite the numbers regularly.'
    },
    {
      'image': 'assets/story_1/image12.png',
      'description':
          'Practice counting by fives. Understanding groups of five will also make learning to tell time much easier.[1] Have your child write down increments of five on a sheet of paper up to 60. As they write the numbers, have them recite them as well. Make sure to point out that each number either ends in a 5 or a 0.[2]'
    },
    {
      'image': 'assets/story_1/image13.png',
      'description':
          'Teach them the general concept of time. General concepts of time are the morning, noon, the evening, and nighttime. Familiarize your kid with these concepts by associating each concept with certain activities. Then quiz your kid by asking them when certain things happen.[3]'
    },
    {
      'image': 'assets/story_1/image14.png',
      'description':
          'Grab 2 paper plates and an analog clock. The paper plates will be used to make the clocks. The analog clock will be used as a reference for making the clocks. Place them on a table and sit with your kid at the table. Let your kid know in an excited voice that, together, you all will be making your very own clocks.'
    },
    {
      'image': 'assets/story_1/image15.png',
      'description':
          'Fold the paper plates into halves. Have your child hold their paper plate and fold it in half. Then rotate the plate and fold it in half again. The paper plates should have a cross-like crease in the middle. You will use this crease as a reference point.'
    },
    {
      'image': 'assets/story_1/image16.png',
      'description':
          'Place stickers and numbers on the clock. Have your child place a sticker on the top of the clock face where the number 12 should be. Then referencing the analog clock, ask them to write the number 12 under the sticker with a marker. Repeat this for the numbers 3, 6, and 9.'
    },
    {
      'image': 'assets/story_1/image17.png',
      'description':
          'Fill in the clock. Once your kid has placed stickers and numbers on the 12, 3, 6, and 9, ask them to fill in the rest of the clock. Show your kid the analog clock as a reference.'
    },
    {
      'image': 'assets/story_1/image18.png',
      'description':
          'Create pie slices on the clock. Have your child draw a line from the center of the clock to each number. Tell your child to color in each pie slice with a different color crayon.'
    },
    {
      'image': 'assets/story_1/image19.png',
      'description':
          'Make the clock hands. Draw 2 clock hands on a poster board—a long one for the minute hand and a short one for the hour hand. Have your child cut out the clock hands with scissors.'
    },
    {
      'image': 'assets/story_1/image20.png',
      'description':
          'Attach the hands. Place the hour hand on top of the minute hand. Pierce a paper fastener through the ends of the clock hands.[11] Then pierce the paper fastener through the middle of the clock. Turn the clock over and bend the fastener ends to secure the clock hands.'
    },
    {
      'image': 'assets/story_1/image21.png',
      'description':
          'Hold the paper clock next to the analog clock. Note how similar they look to your kid. Ask your kid if anything else needs to be added to the clock. If nothing else needs to be added, then you can move on.'
    },
    {
      'image': 'assets/story_1/image22.png',
      'description':
          'Differentiate between the hands. Point to both hands on the clock. Ask your kid what the major difference between the hands is. If they are struggling, you can give them a hint like, “Is one longer than the other?”'
    },
    {
      'image': 'assets/story_1/image23.png',
      'description':
          'Label the clock hands. Once they have identified that the hands are different lengths, then explain the difference. Tell them that the shorthand is the hour hand and the long hand is the minute hand. Have your kid label the hands by writing down “hour” on the shorthand, and “minute” on the long hand.'
    },
    {
      'image': 'assets/story_1/image24.png',
      'description':
          'Explain the hour hand. Point the hour hand at each number, keeping the minute hand at 12 o’clock. Tell your kid that each time the hour hand points at a number and the minute hand points at 12 o’clock, it is ___ o’clock. Go through each number saying, “It is 1 o’clock now. Now it is 2 o’clock. It’s 3 o’clock...” Then have your kid repeat what you just did.'
    },
    {
      'image': 'assets/story_1/image25.png',
      'description':
          'Quiz your child. With your kid’s help, pick a day of the week and write down a list of 5 to 7 activities with their associated times. Call out an activity and its associated time. Have your kid place the hour hand on the correct number. If necessary, gently correct your child’s mistakes.'
    },
    {
      'image': 'assets/story_1/image26.png',
      'description':
          'Explain the double meaning of the numbers. Explaining that the number 1 also means 5 minutes and that the number 2 also means 10 minutes can be quite confusing. To help your kid understand this concept, pretend that the numbers are double agents with a secret identity, like Clark Kent and Superman.'
    },
    {
      'image': 'assets/story_1/image27.png',
      'description':
          'Explain the minute hand’s role. Tell your kid that the numbers’ secret identities come out when the long hand, i.e., the minute hand, points at it. Keeping the hour hand still, point the minute hand at each number and say the associated minutes. Than have your kid repeat the process back to you.'
    },
    {
      'image': 'assets/story_1/image28.png',
      'description':
          'Demonstrate how to read the hour and minute hand together. Once your kid has the concept of the minute hand down, you will need to teach them how to read the hour and minute hands together. Start with simple times such as 1:30, 2:15, 5:45, and so on. Point the hour hand at a number, then point the minute hand at a number. Then say what time it is.'
    },
    {
      'image': 'assets/story_1/image29.png',
      'description':
          'Add tick marks for the non-5 minutes. Once your kid understands 5-minute intervals, add 4 tic marks between each interval. Start by writing 1, 2, 3, and 4 next to the tick marks between the 12 and 1. Encourage your child to fill in the rest of the minutes, counting out loud as you go. Then point the minute hand at a non-5 minute and the hour hand at an hour. Read the time.'
    },
    {
      'image': 'assets/story_1/image30.png',
      'description':
          'Quiz your child. With your child, make a list of 5 to 7 activities with their associated times. Have your kid move the hands of the clock to reflect the activities’ correct times. It is okay to help your kid in the beginning. Just make sure to repeat the activity until your kid can point the hands at the right numbers without your help.'
    },
    {
      'image': 'assets/story_1/image31.png',
      'description':
          'Make it challenging. Once your kid has mastered the activity on their handmade clock, move to the analog clock that does not have the numbers’ secret identities. Repeat the activity with this clock to see how well your kid has mastered the concept of telling time.'
    },
  ];

  Story1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read a Clock'),
        backgroundColor: const Color(0xFFffde59),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: storyData.length,
          itemBuilder: (context, index) {
            final storyItem = storyData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        storyItem['image']!,
                        height:
                            350, // Adjust height for a more rectangular shape
                        width: double.infinity,
                        fit: BoxFit.cover, // Ensures image fills the space
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        storyItem['description']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
