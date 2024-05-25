import React, { useState } from "react";
import {View, Text, TextInput, Button, StyleSheet} from 'react-native';

const DimensionsForRoom = ({ route, navigation }) => {
    const {image} = route.params;
    const [dimensions, setDimensions] = useState({ length: "", width: "", height: "" });

    const handleChange = (key, value) => {
        setDimensions((prevDimensions) => ({
            //single dimension of room
            ...prevDimensions,
            [key]: value,
        }));
    };

    const setRoom = () => {
        navigation.navigate("RoomViewer", {images, dimensions});
    };

    return (
        <View style={styles.container}>
            <Text>Enter Room Dimensions</Text>
            <TextInput
                placeholder="Length"
                value={dimensions.length}
                onChangeText={(text) => handleChange('length', text)}
                style={styles.input}
            />
            <TextInput
                placeholder="Width"
                value={dimensions.width}
                onChangeText={(text) => handleChange('width', text)}
                style={styles.input}
            />
            <TextInput
                placeholder="Height"
                value={dimensions.height}
                onChangeText={(text) => handleChange('height', text)}
                style={styles.input}
            />
            <Button title="Create Room" onPress={setRoom} />
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    input: {
        height: 40,
        borderColor: 'gray',
        borderWidth: 1,
        margin: 10,
        padding: 10,
        width: '80%',
    },
});

export default DimensionsForRoom;