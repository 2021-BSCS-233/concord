const customCategories = {
//    'Technology & Computing': {
//        keywords: ['computer', 'pc', 'laptop', 'desktop', 'mobile', 'device', 'hardware', 'software', 'network', 'internet', 'os', 'app', 'application', 'tech', 'digital'],
//        entities: ['computer', 'laptop', 'desktop', 'smartphone', 'tablet', 'printer', 'router', 'wi-fi', 'operating system', 'windows', 'macos', 'linux', 'android', 'ios', 'software', 'internet', 'network', 'digital device'],
//        subCategories: {
//            'Hardware': {
//                keywords: ['cpu', 'gpu', 'ram', 'storage', 'ssd', 'hdd', 'motherboard', 'monitor', 'keyboard', 'mouse', 'peripherals', 'console', 'camera', 'microphone'],
//                entities: ['cpu', 'gpu', 'ram', 'ssd', 'hard drive', 'motherboard', 'monitor', 'keyboard', 'mouse', 'printer', 'scanner', 'gaming console', 'digital camera']
//            },
//            'Software & OS': {
//                keywords: ['program', 'app', 'application', 'operating system', 'os', 'update', 'install', 'uninstall', 'microsoft office', 'adobe', 'browser', 'antivirus', 'firewall'],
//                entities: ['windows', 'macos', 'linux', 'android', 'ios', 'microsoft office', 'word', 'excel', 'powerpoint', 'adobe photoshop', 'illustrator', 'chrome', 'firefox', 'edge', 'safari', 'antivirus', 'security software']
//            },
//            'Internet & Web': {
//                keywords: ['web', 'website', 'browser', 'online', 'email', 'social media', 'url', 'domain', 'hosting', 'cloud service', 'online privacy'],
//                entities: ['internet', 'world wide web', 'browser', 'google chrome', 'mozilla firefox', 'safari', 'email', 'gmail', 'outlook', 'facebook', 'instagram', 'twitter', 'linkedin', 'cloud computing', 'google drive', 'dropbox']
//            },
//            'Emerging Tech': {
//                keywords: ['ai', 'artificial intelligence', 'ml', 'machine learning', 'blockchain', 'crypto', 'cryptocurrency', 'vr', 'virtual reality', 'ar', 'augmented reality', 'iot', 'smart device', 'robotics'],
//                entities: ['artificial intelligence', 'machine learning', 'neural network', 'blockchain', 'bitcoin', 'ethereum', 'nft', 'virtual reality', 'augmented reality', 'iot device', 'smart home', 'robotics']
//            }
//        }
//    },
    'Programming': {
        keywords: ['code', 'coding', 'program', 'programming', 'developer', 'script', 'function', 'variable', 'class', 'object', 'bug', 'debugging', 'git', 'framework', 'library', 'sdk', 'ide', 'compiler', 'version control', 'devops', 'cloud', 'deployment', 'algorithm', 'data structure'],
        entities: ['api', 'database', 'sql', 'nosql', 'firebase', 'mongodb', 'postgresql', 'mysql', 'server', 'backend', 'frontend', 'ui', 'ux', 'ide', 'git', 'github', 'gitlab', 'bitbucket', 'docker', 'kubernetes', 'aws', 'azure', 'google cloud'],
        subCategories: {
            'Python': {
                keywords: ['python', 'django', 'flask', 'pandas', 'numpy', 'scipy', 'data science', 'machine learning', 'ai', 'ml', 'data analysis', 'automation'],
                entities: ['python', 'django', 'flask', 'tensorflow', 'pytorch', 'scikit-learn', 'pandas', 'numpy', 'jupyter']
            },
            'JavaScript': {
                keywords: ['javascript', 'js', 'node', 'nodejs', 'express', 'react', 'angular', 'vue', 'npm', 'webdev', 'frontend', 'backend', 'typescript'],
                entities: ['javascript', 'node js', 'nodejs', 'express.js', 'react.js', 'angular', 'vue.js', 'npm', 'typescript', 'webpack', 'babel', 'redux', 'next.js', 'nest.js']
            },
            'Flutter': {
                keywords: ['flutter', 'dart', 'widget', 'ui', 'material design', 'state management', 'mobiledev', 'android app', 'ios app', 'mobile app'],
                entities: ['flutter', 'dart', 'widget', 'materialapp', 'scaffold', 'riverpod', 'bloc', 'getx', 'provider', 'firebase flutter', 'android', 'ios']
            },
            'Firebase': {
                        keywords: ['firebase', 'firestore', 'realtime database', 'authentication', 'auth', 'cloud functions', 'hosting', 'storage', 'analytics', 'crashlytics', 'messaging', 'fcm'],
                        entities: ['firebase', 'firestore', 'realtime database', 'firebase authentication', 'firebase functions', 'firebase hosting', 'cloud firestore', 'cloud functions', 'firebase storage', 'firebase analytics', 'firebase crashlytics', 'firebase cloud messaging', 'fcm']
            },
            'C# & .NET': {
                keywords: ['c#', 'csharp', '.net', 'dotnet', 'asp.net', 'unity', 'game dev'],
                entities: ['c#', 'csharp', '.net', 'dotnet', 'asp.net', 'unity3d', 'xaml']
            },
            'Java & Android': {
                keywords: ['java', 'android', 'spring', 'kotlin', 'jvm'],
                entities: ['java', 'android', 'kotlin', 'spring boot', 'gradle', 'maven']
            },
            'Databases': {
                keywords: ['database', 'db', 'sql', 'nosql', 'query', 'schema', 'table', 'collection', 'document', 'mongodb', 'postgresql', 'mysql', 'firebase', 'firestore', 'realm', 'data storage'],
                entities: ['database', 'sql', 'nosql', 'mongodb', 'postgresql', 'mysql', 'firebase', 'firestore', 'sqlite', 'redis', 'cassandra', 'dynamodb']
            },
            'APIs & Networking': {
                keywords: ['api', 'rest', 'graphql', 'http', 'https', 'endpoint', 'request', 'response', 'server', 'client', 'json', 'xml', 'socket', 'websocket', 'networking', 'connection', 'protocol'],
                entities: ['api', 'rest api', 'graphql', 'http', 'https', 'json', 'xml', 'websocket', 'server', 'client', 'network', 'connection', 'protocol', 'tcp/ip']
            },
            'Frontend Development': {
                keywords: ['frontend', 'ui', 'ux', 'html', 'css', 'javascript', 'responsive design', 'web design', 'user interface'],
                entities: ['html', 'css', 'javascript', 'responsive design', 'web design', 'user interface', 'user experience', 'react', 'angular', 'vue.js', 'sass', 'less', 'bootstrap', 'tailwind css']
            },
            'Backend Development': {
                keywords: ['backend', 'server-side', 'api', 'database', 'authentication', 'authorization', 'security', 'microservices', 'load balancing'],
                entities: ['backend', 'server-side', 'api', 'rest', 'graphql', 'database', 'sql', 'nosql', 'authentication', 'authorization', 'security', 'microservices', 'nginx', 'apache']
            }
        }
    },
    'Education & Learning': {
        keywords: ['study', 'learn', 'education', 'school', 'university', 'college', 'course', 'subject', 'exam', 'homework', 'assignment', 'research', 'essay', 'student', 'teacher', 'professor', 'lecture', 'tutorial', 'syllabus', 'academic', 'degree'],
        entities: ['education', 'learning', 'school', 'university', 'college', 'exam', 'homework', 'assignment', 'research paper', 'essay', 'student', 'teacher', 'professor', 'lecture', 'tutorial', 'syllabus', 'academic degree'],
        subCategories: {
            'Academic Subjects': {
                keywords: ['mathematics', 'history', 'literature', 'language', 'science', 'physics', 'chemistry', 'biology', 'geography', 'economics', 'psychology', 'sociology', 'philosophy', 'art history'],
                entities: ['mathematics', 'history', 'literature', 'english', 'french', 'spanish', 'german', 'science', 'physics', 'chemistry', 'biology', 'geography', 'economics', 'psychology', 'sociology', 'algebra', 'calculus', 'geometry', 'statistics']
            },
            'Study Skills': {
                keywords: ['study tips', 'exam prep', 'note-taking', 'time management', 'focus', 'memory', 'reading comprehension', 'research skills', 'writing skills'],
                entities: ['study skills', 'exam preparation', 'note-taking', 'time management', 'focus', 'memory techniques', 'reading comprehension', 'research skills', 'writing skills']
            },
            'Online Learning': {
                keywords: ['online course', 'e-learning', 'webinar', 'mooc', 'virtual classroom', 'remote learning'],
                entities: ['online course', 'e-learning', 'mooc', 'virtual classroom', 'coursera', 'edx', 'udemy']
            }
        }
    },
    'Health & Wellness': {
        keywords: ['health', 'wellness', 'fitness', 'exercise', 'diet', 'nutrition', 'medicine', 'doctor', 'symptom', 'disease', 'mental health', 'therapy', 'stress', 'sleep', 'well-being'],
        entities: ['health', 'wellness', 'fitness', 'exercise', 'diet', 'nutrition', 'medical condition', 'disease', 'medication', 'doctor', 'hospital', 'mental health', 'therapy', 'stress management', 'sleep quality', 'well-being'],
        subCategories: {
            'Physical Health': {
                keywords: ['nutrition', 'diet', 'exercise', 'workout', 'fitness routine', 'weight loss', 'muscle gain', 'cardio', 'strength training', 'injury', 'recovery', 'illness', 'symptom', 'treatment', 'medication', 'first aid'],
                entities: ['nutrition', 'diet plan', 'exercise', 'workout', 'fitness routine', 'weight loss', 'muscle gain', 'cardio', 'strength training', 'injury recovery', 'illness', 'symptom', 'medical treatment', 'medication', 'first aid']
            },
            'Mental Health': {
                keywords: ['mental health', 'anxiety', 'depression', 'stress', 'mindfulness', 'meditation', 'therapy', 'counseling', 'well-being', 'self-care', 'emotional health'],
                entities: ['mental health', 'anxiety', 'depression', 'stress management', 'mindfulness', 'meditation', 'therapy', 'counseling', 'emotional well-being', 'self-care']
            },
            'Diet & Nutrition': {
                keywords: ['diet', 'nutrition', 'food', 'recipe', 'meal plan', 'calories', 'protein', 'carbs', 'fats', 'vitamins', 'supplements', 'vegan', 'vegetarian', 'gluten-free'],
                entities: ['diet', 'nutrition', 'meal plan', 'calories', 'protein', 'carbohydrates', 'fats', 'vitamins', 'minerals', 'supplements', 'vegan diet', 'vegetarian diet', 'gluten-free diet']
            }
        }
    },
    'Home & Lifestyle': {
        keywords: ['home', 'house', 'living', 'food', 'recipe', 'cook', 'bake', 'garden', 'diy', 'repair', 'finance', 'money', 'budget', 'invest', 'pet', 'family', 'parenting', 'hobby', 'craft', 'travel', 'fashion', 'style'],
        entities: ['home', 'house', 'apartment', 'recipe', 'cooking', 'baking', 'gardening', 'diy project', 'home repair', 'personal finance', 'budgeting', 'investing', 'pet care', 'dog', 'cat', 'family life', 'parenting', 'hobby', 'craft', 'travel planning', 'fashion', 'style'],
        subCategories: {
            'Cooking': {
                keywords: ['recipe', 'cook', 'bake', 'cuisine', 'ingredients', 'baking', 'dessert', 'meal prep', 'vegetarian', 'vegan', 'quick meals'],
                entities: ['recipe', 'cooking', 'baking', 'italian cuisine', 'chinese cuisine', 'indian cuisine', 'dessert', 'meal preparation', 'vegan recipe', 'vegetarian recipe']
            },
            'Home Improvement & DIY': {
                keywords: ['home improvement', 'diy', 'repair', 'renovation', 'gardening', 'landscaping', 'decorating', 'design', 'tools', 'plumbing', 'electrical'],
                entities: ['home improvement', 'diy project', 'home repair', 'renovation', 'gardening', 'landscaping', 'interior design', 'decorating', 'power tools', 'plumbing', 'electrical work']
            },
            'Personal Finance': {
                keywords: ['finance', 'money', 'budget', 'saving', 'investing', 'debt', 'taxes', 'retirement', 'credit score', 'loan'],
                entities: ['personal finance', 'budgeting', 'saving money', 'investing', 'debt management', 'taxes', 'retirement planning', 'credit score', 'loan']
            },
            'Parenting & Family': {
                keywords: ['parenting', 'child', 'baby', 'toddler', 'teenager', 'family', 'child development', 'education choices', 'discipline'],
                entities: ['parenting', 'child care', 'child development', 'family dynamics', 'baby care', 'toddler development', 'teenager issues', 'education choices', 'discipline techniques']
            },
            'Hobbies & Crafts': {
                keywords: ['hobby', 'craft', 'art', 'music', 'gaming', 'photography', 'knitting', 'sewing', 'drawing', 'painting', 'collecting'],
                entities: ['hobby', 'crafts', 'art projects', 'musical instrument', 'board games', 'video games', 'photography', 'knitting', 'sewing', 'drawing', 'painting', 'collecting stamps', 'collecting coins']
            }
        }
    },
    'Arts & Culture': {
        keywords: ['art', 'culture', 'music', 'dance', 'theater', 'film', 'movie', 'tv show', 'book', 'literature', 'painting', 'drawing', 'sculpture', 'photography', 'design', 'history', 'tradition', 'museum', 'gallery', 'concert'],
        entities: ['art', 'culture', 'music', 'dance', 'theater', 'film', 'movie', 'tv show', 'book', 'literature', 'painting', 'drawing', 'sculpture', 'photography', 'graphic design', 'museum', 'art gallery', 'concert', 'opera', 'ballet'],
        subCategories: {
            'Visual Arts': {
                keywords: ['painting', 'drawing', 'sculpture', 'photography', 'digital art', 'art history', 'art techniques', 'gallery', 'museum'],
                entities: ['painting', 'drawing', 'sculpture', 'photography', 'digital art', 'art history', 'art techniques', 'art gallery', 'museum']
            },
            'Performing Arts': {
                keywords: ['music', 'song', 'instrument', 'band', 'genre', 'dance', 'ballet', 'theater', 'play', 'drama', 'acting'],
                entities: ['music', 'musical instrument', 'music genre', 'band', 'dance', 'ballet', 'theater', 'play', 'acting', 'performer']
            },
            'Literature': {
                keywords: ['book', 'novel', 'story', 'author', 'poetry', 'poem', 'fiction', 'non-fiction', 'genre', 'literary analysis', 'reading'],
                entities: ['book', 'novel', 'short story', 'author', 'poetry', 'poem', 'fiction', 'non-fiction', 'literary genre', 'literary analysis', 'reading']
            },
            'Film & Television': {
                keywords: ['film', 'movie', 'tv show', 'series', 'actor', 'director', 'genre', 'streaming', 'review', 'cinema'],
                entities: ['film', 'movie', 'tv show', 'television series', 'actor', 'director', 'film genre', 'streaming service', 'movie review', 'cinema']
            }
        }
    },
    'News': {
        keywords: ['news', 'event', 'current affairs', 'update', 'headlines', 'breaking news', 'report', 'media', 'journalism'],
        entities: ['news', 'current events', 'breaking news', 'news report', 'media', 'journalism'],
        subCategories: {
            'Politics & Government': {
                keywords: ['politics', 'government', 'election', 'vote', 'policy', 'law', 'legislation', 'parliament', 'congress', 'president', 'prime minister'],
                entities: ['politics', 'government', 'election', 'voting', 'public policy', 'law', 'legislation', 'parliament', 'congress', 'president', 'prime minister', 'political party']
            },
            'Social Issues': {
                keywords: ['social issue', 'society', 'community', 'equality', 'justice', 'human rights', 'activism', 'poverty', 'education system', 'healthcare system'],
                entities: ['social issue', 'social justice', 'equality', 'human rights', 'activism', 'poverty', 'education system', 'healthcare system', 'climate change', 'environmental issue']
            },
            'World News': {
                keywords: ['world news', 'international relations', 'global event', 'diplomacy', 'conflict', 'geopolitics', 'country', 'region'],
                entities: ['world news', 'international relations', 'global event', 'diplomacy', 'military conflict', 'geopolitics', 'country', 'region']
            },
            'Local News': {
                keywords: ['local news', 'community event', 'city council', 'town hall', 'local government', 'neighborhood'],
                entities: ['local news', 'community event', 'city council', 'town hall', 'local government', 'neighborhood']
            }
        }
    }
};

function classifyPostByEntities(entities, originalText) {
    const detectedCategories = new Set();
    const lowerCaseText = originalText.toLowerCase();

    const checkCategoryMatches = (categoryRule) => {
//        for (const keyword of categoryRule.keywords) {
//            if (lowerCaseText.includes(keyword.toLowerCase())) {
//                return true;
//            }
//        }
        for (const entity of entities) {
            for (const expectedEntity of categoryRule.entities) {
                if (entity.name.toLowerCase().includes(expectedEntity.toLowerCase())) {
                    return true;
                }
            }
        }
        return false;
    };

    for (const mainCategoryName in customCategories) {
        const mainCategoryRules = customCategories[mainCategoryName];
        if (checkCategoryMatches(mainCategoryRules)) {
            detectedCategories.add(mainCategoryName);
        }
        if (mainCategoryRules.subCategories) {
            for (const subCategoryName in mainCategoryRules.subCategories) {
                const subCategoryRules = mainCategoryRules.subCategories[subCategoryName];
                if (checkCategoryMatches(subCategoryRules)) {
                    detectedCategories.add(subCategoryName);
                    detectedCategories.add(mainCategoryName);
                }
            }
        }
    }
    if (detectedCategories.size === 0) {
            detectedCategories.add('Miscellaneous');
    }

    return Array.from(detectedCategories);
}

module.exports = {
    customCategories,
    classifyPostByEntities
};