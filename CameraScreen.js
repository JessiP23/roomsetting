import React, {useState} from 'react';
import { View, Button, Image, StyleSheet } from 'react-native';
import { launchCamera } from 'react-native-image-picker';

const ScreenCamera = ({ navigation }) => {
    const [images, setImages] = useState({
        //update sides of room
        wall1: null,
        wall2: null,
        wall3: null,
        wall4: null,
        roof: null,
        floor: null
    });

    const pickPicture = (key) => {
        launchCamera({ mediaType: "photo" }, (response) => {
            if (response.assets) {
                setImages((prevImages) => ({
                    ...prevImages,
                    [key]: response.assets[0].uri,
                }));
            }
        });
    };

    return (
        <View style={styles.container}>
            <Button title='Capture Wall 1' onPress={() => pickPicture('wall1')} />
            {images.wall1 && <Image source={{ uri: images.wall1 }} style={styles.image} />}
            <Button title='Capture Wall 2' onPress={() => pickPicture('wall2')} />
            {images.wall2 && <Image source={{ uri: images.wall2 }} style={styles.image} />}
            <Button title='Capture Wall 3' onPress={() => pickPicture('wall3')} />
            {images.wall3 && <Image source={{ uri: images.wall3 }} style={styles.image} />}
            <Button title='Capture Wall 4' onPress={() => pickPicture('wall4')} />
            {images.wall4 && <Image source={{ uri: images.wall4 }} style={styles.image} />}
            <Button title='Capture Roof' onPress={() => pickPicture('roof')} />
            {images.roof && <Image source={{ uri: images.roof }} style={styles.image} />}
            <Button title='Capture Floor' onPress={() => pickPicture('floor')} />
            {images.floor && <Image source={{ uri: images.floor }} style={styles.image} />}
            <Button title='Next' onPress={() => navigation.navigate('Dimensions', {images})} />
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    image: {
        width: 100,
        height: 100,
        margin: 10,
    },
});

export default ScreenCamera;