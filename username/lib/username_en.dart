import 'username.dart';

class ENUsername extends Username {
  ENUsername({String? surName, String? givenName})
      : super(surName: surName, givenName: givenName);

  String get fullname => getSurName() + getGivenName();

  // 姓氏
  List<String> get topSurNames {
    final names =
        'Adams, Alexander, Ali, Allen, Anderson, Bailey, Baker, Barnes, Bell, Bennett, Brooks, Brown, Butler, Campbell, Carter, Clark, Clarke, Collins, Cook, Cooper, Cox, Cruz, Davies, Davis, Diaz, Doherty, Driscoll, Edwards, Evans, Fisher, Flores, Foster, Garcia, Gomez, Gonzalez, Graham, Gray, Green, Griffiths, Gutierrez, Hall, Hamilton, Harris, Hernandez, Hill, Howard, Hughes, Jackson, James, Jenkins, Johnson, Johnston, Jones, Kelly, Khan, King, Lee, Lewis, Long, Lopez, MacDonald, Martin, Martinez, Mason, McLaughlin, Miller, Mitchell, Moore, Morales, Morgan, Morris, Morrison, Moss, Murphy, Murray, Myers, Nelson, Nguyen, ONeill, Ortiz, Owen, Parker, Patel, Paterson, Perez, Perry, Peterson, Phillips, Powell, Price, Quinn, Ramirez, Reed, Rees, Reid, Reyes, Richardson, Rivera, Roberts, Robertson, Robinson, Rodriguez, Rodríguez, Rogers, Rose, Ross, Russell, Sanchez, Sanders, Scott, Smith, Smyth, Stewart, Sullivan, Taylor, Thomas, Thompson, Thomson, Torres, Turner, Walker, Ward, Watson, White, Williams, Wilson, Wood, Wright, Young';

    // return names.split(',');
    return splitCommaString(names);
  }

  // 名称
  List<String> get topGivenNames {
    final names =
        'Aaliyah, Abigail, Addison, Adrian, Adriana, Aiden, Alanis, Alexander, Alexandra, Alexis, Allison, Alondra, Alyssa, Amanda, Amelia, Andrea, Andrew, Angel, Anna, Anthony, Aria, Ariana, Ashley, Aspen, Aubree, Aubrey, Aurora, Austin, Ava, Avery, Benjamin, Bentley, Brantley, Braxton, Brayden, Brianna, Bridger, Brody, Brooklyn, Caleb, Cameron, Camila, Carlos, Caroline, Carter, Charles, Charlotte, Charlottte, Chase, Chloe, Christian, Christopher, Claire, Colton, Connor, Cooper, Daniel, David, Diego, Dylan, Easton, Eleanor, Eli, Elijah, Elizabeth, Ella, Ellie, Emily, Emma, Ethan, Evan, Evelyn, Ezekiel, Ezra, Faith, Gabriel, Gabriela, Gabriella, Gavin, Genesis, Gianna, Grace, Grayson, Hadley, Hailey, Hannah, Harper, Hazel, Henry, Hudson, Hunter, Ian, Isaac, Isabella, Isaiah, Jace, Jack, Jackson, Jacob, James, Jaxon, Jayden, Jeremiah, Jesus, John, Jose, Joseph, Joshua, Josiah, Juan, Julia, Julian, Kamila, Katherine, Kayla, Kaylee, Kevin, Khloe, Kingston, Landon, Layla, Leah, Levi, Liam, Lillian, Lily, Lincoln, Logan, Lucas, Lucy, Luis, Luke, Lydia, Madison, Makayla, Mary, Mason, Matthew, Maya, Mia, Micah, Michael, Mila, Naomi, Natalie, Nathan, Nevaeh, Nicholas, Nicole, Noah, Nora, Oakley, Oliver, Olivia, Owen, Paisley, Paola, Parker, Piper, Riley, Robert, Ruby, Ryan, Ryker, Sadie, Samantha, Samuel, Sarah, Savannah, Sawyer, Scarlett, Sebastian, Serenity, Skylar, Sofia, Sophia, Taylor, Theodore, Tyler, Valeria, Victoria, William, Wyatt, Ximena, Yadiel, Zoe, Zoey';

    // return names.split(',');
    return splitCommaString(names);
  }
}
