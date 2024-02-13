const textMainmenuGotoAbout = 'read *about* AssTra';
const textAboutPreText='How can an ass (the animal not the body part!) reach for the stars (lat. astra)? No idea, but training and knowledge might help.';
const textAboutTitle='*About AssTra*';
const textAboutVersion='v0.1';
const textAboutBackButton='Back';
const textAboutPreviousButton='<';
const textAboutNextButton='>';

const textPoweredBy='''AssTra is powered by IKS GmbH
''';

const textAboutDescription='''AssTra stands for *Association Trainer*. It works that way:

  a) For an interesting knowledge field create a text file which contains associations as pairs of data items
  
  b) Import this file as new Knowledge Field into the library of AssTra
  
  c) Train those associations with Asstra like using a set of flash cards
  
  d) Play AssTra like playing a quiz, which gives you a rating
  
  e) Get top places in AssTra's "Hall of Fame"
  
  f) Play the Endless Game
  
More information about AssTra you find in the FAQs:
''';

const textAboutFAQ_1_Title='FAQ 1. What is an association?';
const textAboutFAQ_1_Text='''
A pair of data items that relate to each other in any form and therefore belong together like

    Denmark - Copenhagen 
    (country - capital)
    
    beach - playa 
    (english - spanish)
    
    Oxygen - 8 
    (chemical element - # protons)
    
The first data item of an association is called *key*, the second *value*. 
''';

const textAboutFAQ_2_Title='FAQ 2. What is the direction of an association?';
const textAboutFAQ_2_Text='''
When you have a key and are looking for a value, then you follow the *forward* direction. The *backward* direction (finding the key for a given value) is only available, if each key has its own (unambiguous) value. 
''';

const textAboutFAQ_3_Title='FAQ 3. What is a Knowledge Field?';
const textAboutFAQ_3_Text='''
In AssTra this is a collection of associations for topics as mentioned in FAQ 1. A Knowledge Field is defined by the combination of key name and value name. Knowledge Fields for which the backward direction is not available (see FAQ 2) are labelled as one-way. Otherwise two-way. 
''';

const textAboutFAQ_4_Title='FAQ 4. What is a Knowledge Area?';
const textAboutFAQ_4_Text='''
In AssTra this is a collection of Knowledge Fields that closely relate to each other like

physicist - discovery
quantity - unit
name - formula 

Those three Knowledge Fields could represent the Knowledge Area 'Physics'. You define a Knowledge Area as a property of a Knowledge Field (see FAQ 5). 
''';

const textAboutFAQ_5_Title='FAQ 5. What must an import file look like?';
const textAboutFAQ_5_Text='''
The *first line* must contains the area of the Knowledge Field and the *second line* key name and value name separated by a hash tag. The *third line* represents the question that is asked in the forward direction, the *fourth line* the question for the backward question. For oneWay-KnowledgeFields the third line is supposed to be empty. The following lines contain the data item pairs separated by the # symbol. Make sure to have at least 10 associations in your knowledge field.

*For example:*
chemistry
chemical # formula
What is the formula of <chemical>?
How is <formula> called?
Oxygen # O2
Methane # CH4
...

Note that the questions are actually templates containing a placeholder. AssTra will replace it while training and playing.
''';

const textAboutFAQ_6_Title='FAQ 6. What is a quest?';
const textAboutFAQ_6_Text='''
A quest is a question combined with a number of possible answers. You simply have to choose one of those answers to complete the quest by touching on it.
''';

const textAboutFAQ_7_Title='FAQ 7. How does Training works in AssTra?';
const textAboutFAQ_7_Text='''
You only can train single Knowledge Fields - no Knowledge Areas. 
AssTra cuts all the associations of a single Knowledge Field into blocks. While training, AssTra presents you associations of such a block in random quest order. For each association AssTra counts the number of correct quests separately. If your answer is wrong the count is reset to 0. If this count reaches the *Learned-Limit*, Asstra regards this association as 'Learned' and will stop creating quests for it. 
If you have no or small knowledge, those blocks of associations are small, otherwise a bit bigger.
''';

const textAboutFAQ_8_Title='FAQ 8. How to play with AssTra?';
const textAboutFAQ_8_Text='''
You may play on Knowledge Area or Knowledge Field level. You may play a defined number of minutes (*race*) or quests (*match*) as a quiz. If available, you may play in different directions. You choose your options in the AssTra start dialog. 
In case of not a single wrong quest, the number of quests is taken as score. If the Highscore list isn't full or you are better than the last entry than you enter the Hall of Fame.
''';

const textAboutFAQ_9_Title='FAQ 9. What is the Endless Quiz?';
const textAboutFAQ_9_Text='''
This the master or supreme discipline of AssTra. You collect scores without any special aim. You also loose scores for too many wrong quests in sequence. For each quest, the Endless Quiz randomly picks a Knowledge Area. From that it picks randomly a Knowledge Field. If Two-Way, it picks randomly a direction and finally an association. 
When ever a Knowledge Field is added or removed, the Score will be reset. 
''';

